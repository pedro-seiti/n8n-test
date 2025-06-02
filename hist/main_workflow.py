from decimal import Decimal

values = []
average = 0
count = 0
for item in _input.all():
  values.append(float(item.json.consumption_in_kwh))

n = len(values)
avg = sum(values) / n

square_sum = sum((x - avg) ** 2 for x in values)
std_deviation = (square_sum / (n - 1)) ** 0.5

limit = 2

results = []
for item in _input.all():
  json_res = {}
  json_res['clientName'] = item.json.name
  json_res['avgConsumption'] = item.json.consumption_in_kwh
  kwh = float(item.json.consumption_in_kwh)
  z = (kwh - avg) / std_deviation
  if (abs(z) > limit):
    json_res['consumptionStatus'] = 'outlier'
  else:
    json_res['consumptionStatus'] = 'normal'

  results.append(json_res)

return results