module Api
  module V1
    class ApplicationController < ActionController::API
      include ActionController::Caching

      class ParameterValueNotAllowed < ActionController::ParameterMissing
        attr_reader :values
        def initialize(param, values)
          @param = param
          @values = values
          super("param: #{param} value only allowed in: #{values}")
        end
      end

      class AccessDenied < StandardError; end

      class PageNotFound < StandardError; end

      rescue_from(ActionController::ParameterMissing) do |err|
        render json: { error: 'ParameterInvalid', message: err }, status: 400
      end
      rescue_from(ActiveRecord::RecordInvalid) do |err|
        render json: { error: 'RecordInvalid', message: err }, status: 400
      end
      rescue_from(AccessDenied) do |err|
        render json: { error: 'AccessDenied', message: err }, status: 403
      end
      rescue_from(ActiveRecord::RecordNotFound) do
        render json: { error: 'ResourceNotFound' }, status: 404
      end

      def requires!(name, opts = {})
        opts[:require] = true
        optional!(name, opts)
      end

      def optional!(name, opts = {})
        if opts[:require] && !params.has_key?(name)
          raise ActionController::ParameterMissing.new(name)
        end

        if opts[:values] && params.has_key?(name)
          values = opts[:values].to_a
          if !values.include?(params[name]) && !values.include?(params[name].to_i)
            raise ParameterValueNotAllowed.new(name, opts[:values])
          end
        end

        params[name] ||= opts[:default]
      end
      
      def error!(data, status_code = 400)
        render json: data, status: status_code
      end

      def error_404!
        error!({ 'error' => 'Page not found' }, 404)
      end

    end
  end
end