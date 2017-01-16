local data = {}
data['trigger1'] = {}
data['trigger2'] = {}
data['trigger1']['x'] = 150
data['trigger1']['triggerHook'] = 'trigger1'
data['trigger1']['y'] = 0
data['trigger1']['width'] = 100
data['trigger1']['height'] = 10
data['trigger1']['onFire'] = 'playerHolding'
data['trigger2']['data'] = {}
data['trigger2']['x'] = -30
data['trigger2']['triggerHook'] = 'overlappingPlant'
data['trigger2']['y'] = 0
data['trigger2']['data']['plantName'] = 'Flower'
data['trigger2']['data']['plantId'] = 'plant1'
data['trigger2']['height'] = 20
data['trigger2']['width'] = 20
return data