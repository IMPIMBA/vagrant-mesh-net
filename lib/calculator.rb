# -*- mode: ruby -*-
# vi: set ft=ruby :
# Thanks to: CHRISTOPHER L. LYDICK (http://hdl.handle.net/2097/808)

PRIMARYOCTET = "17.0"

def calculateIPs(base)
  adresses = Array[]
  for z in 0..(base-1)
    for y in 0..(base-1)
      for x in 0..(base-1)
        calcXAdress(base, x, y, z, adresses)
        calcYAdress(base, x, y, z, adresses)
        calcZAdress(base, x, y, z, adresses)
      end
    end
  end

  return adresses
end

def calcXAdress(k, x, y, z, adresses)
  dir_mod_pos = 1
  dir_mod_neg = 2

  poscoctet = ((x << 4) + y)
  if x == 0
    negcoctet = ((k - 1) << 4) + y
  else
    negcoctet = ((x - 1) << 4) + y
  end

  posdoctet = (z << 4) + dir_mod_pos;
  negdoctet = (z << 4) + dir_mod_neg;

  posxip = PRIMARYOCTET + "." + poscoctet.to_s + "." + posdoctet.to_s
  negxip = PRIMARYOCTET + "." + negcoctet.to_s + "." + negdoctet.to_s

  adresses.push(posxip)
  adresses.push(negxip)
end

def calcYAdress(k, x, y, z, adresses)
  dir_mod_pos = 5
  dir_mod_neg = 6

  poscoctet = ((x << 4) + y)
  if y == 0
    negcoctet = (x << 4) + (k - 1)
  else
    negcoctet = (x << 4) + (y - 1)
  end

  posdoctet = (z << 4) + dir_mod_pos
  negdoctet = (z << 4) + dir_mod_neg

  posyip = PRIMARYOCTET + "." + poscoctet.to_s + "." + posdoctet.to_s
  negyip = PRIMARYOCTET + "." + negcoctet.to_s + "." + negdoctet.to_s

  adresses.push(posyip)
  adresses.push(negyip)
end

def calcZAdress(k, x, y, z, adresses)
  dir_mod_pos =  9
  dir_mod_neg = 10

  coctet = (x << 4) + y
  posdoctet = (z << 4) + dir_mod_pos
  if z == 0
    negdoctet = ((k - 1) << 4) + dir_mod_neg
  else
    negdoctet = ((z - 1) << 4) + dir_mod_neg
  end

  poszip = PRIMARYOCTET + "." + coctet.to_s + "." + posdoctet.to_s
  negzip = PRIMARYOCTET + "." + coctet.to_s + "." + negdoctet.to_s

  adresses.push(poszip)
  adresses.push(negzip)
end

# Write all IPs in array to file
def writeIPout(addresses)
  File.open("./serverspec/meships", "w") do |meships|
    (1..27).each do |nodenr|
      meships.puts("node" + nodenr.to_s)
      index = (nodenr - 1) * 6
      meships.puts(addresses[index + 0] + " posX")
      meships.puts(addresses[index + 1] + " negX")
      meships.puts(addresses[index + 2] + " posY")
      meships.puts(addresses[index + 3] + " negY")
      meships.puts(addresses[index + 4] + " posZ")
      meships.puts(addresses[index + 5] + " negZ")
    end
  end
end

# Temporarly method to read mgmt IPs
def getServiceNodeIPs()
  ipadresses = Array[]

  File.open("servicenode-attach-ips", "r").each_line do |line|
    ipadresses.push(line.strip)
  end

  ipadresses
end
