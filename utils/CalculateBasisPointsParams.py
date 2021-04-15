# This amount should be representable as basis points
resolution = 1

totalSupply = 64000000*(1E18)

resolutionAsPercentage = (resolution*100)/totalSupply

taxes = 10000*(1E18)

holdings = 640*(1E18)

for i in range(1, 500):
    basisPointFactor = 10**i
    if(resolutionAsPercentage*(basisPointFactor) % 1 == 0):
        necessaryExponent = i
        break

proportionFactor = (holdings*basisPointFactor)/totalSupply

reward = (taxes * proportionFactor) / basisPointFactor

print('Target percentage: ' + str(resolutionAsPercentage))
print('Holdings: ' + str(holdings))
print('Necessary exponent: ' + str(necessaryExponent))
print('Porportion factor ' + str(proportionFactor))
print('Rewards: ' + str(reward))
