json.code 200
json.documents do
  json.partial! 'document', document: @document, change: @change
end