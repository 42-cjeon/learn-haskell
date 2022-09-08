obj = '{' field *(',' field) '}'

field = string ':' field-value

field-value = (string | array | obj)

array = '[' field-value *(',' field-value) ']'
