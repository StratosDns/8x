string = ["raceId","circuitId","driverId","points","forename","surname"]

dict = {"circuitId" : "raceId"}, {"forename" : "driverId"}, {"surname" : "driverId"}

X = ["raceId","driverId"]
OX = X
i = 0
while X != OX:
    for word in dict:
        if dict[word] in OX:
            OX.append(word)
            i += 1
            print(i," ",OX)

print("OX:", OX)
print("X:", X)