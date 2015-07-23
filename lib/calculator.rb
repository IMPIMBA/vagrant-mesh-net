# -*- mode: ruby -*-
# vi: set ft=ruby :
# Thanks to: CHRISTOPHER L. LYDICK (http://ece.k-state.edu/sunflower_wiki/images/archive/8/85/20080514163321!Lydick_thesis_noappendix.pdf)

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

  #puts("POSX = " + posxip)
  #puts("NEGX = " + negxip)
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

  #puts("POSY = " + posyip)
  #puts("NEGY = " + negyip)
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

  #puts("POSZ = " + poszip)
  #puts("NEGZ = " + negzip)
end
