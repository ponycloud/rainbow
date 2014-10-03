angular.module "pony.bytes", ["ng"]

bytes2any = (bytes, precision, offset) ->
    return "-"  if isNaN(parseFloat(bytes)) or not isFinite(bytes)
    precision = 1  if typeof precision is "undefined"
    units = [
      "bytes"
      "KiB"
      "MiB"
      "GiB"
      "TiB"
      "PiB"
      "EiB"
      "ZiB"
      "YiB"
    ]
    number = Math.floor(Math.log(bytes) / Math.log(1024))
    (bytes / Math.pow(1024, Math.floor(number))).toFixed(precision) + " " + units[number+offset]


angular.module("pony.bytes").filter "bytes", ($parse, $timeout) ->
  (bytes, precision) ->
    bytes2any(bytes, precision)


angular.module("pony.bytes").filter "megabytes", ($parse, $timeout) ->
  (megabytes, precision) ->
    bytes2any(megabytes, precision, 2)

