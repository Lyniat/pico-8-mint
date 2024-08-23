--lander

function _init()
 spiel_gestartet = false

 erstelle_spiel()
 erstelle_spieler()
end

function erstelle_spiel()
 spiel_verloren = false
 spiel_gewonnen = false
 schwerkraft = 0.025

 spr_spieler = 1
 spr_fahne = 4
 spr_explosion = 5
 spr_feuer = 33

 erstelle_spieler()
end

function _update()
 if (not spiel_gestartet) then
  if btnp(5) then
   spiel_gestartet = true
  end
 else
  if not spiel_verloren then
   bewege_spieler()
   ist_gelandet()
  else
   if btnp(5) then
    erstelle_spiel()
   end
  end
 end
end

function _draw()
 cls()
 if (not spiel_gestartet) then
  -- (128 / 2) - ((15 / 2) * 4) = 36
  print("die mondlandung",36,48,7)
  -- (128 / 2) - ((13 / 2) * 4) = 40
  print("ein spiel von",40,62,13)
  -- (128 / 2) - ((11 / 2) * 4) = 44
  print("laurin muth",44,69,13)
 else
  map(0, 0, 0, 0, 16, 16)
  map(0, 16, 0, 0, 16, 16)
  zeichne_spieler()

  if spiel_verloren then
   if spiel_gewonnen then
    -- (128 / 2) - ((15 / 2) * 4) = 36
    print("spiel gewonnen!", 36, 48, 11)
   else
    -- (128 / 2) - ((10 / 2) * 4) = 44
    print("so schade!", 44, 48, 8)
   end
   -- (128 / 2) - ((19 / 2) * 4) = 28
   print("neuer versuch mit ❎", 28, 70, 5)
  end
 end
end

function erstelle_spieler()
 sp_x = 60
 sp_y = 8
 sp_ux = 0
 sp_uy = 0
 sp_schub = 0.075
end

function zeichne_spieler()
 spr(spr_spieler, sp_x, sp_y)
 if spiel_verloren and spiel_gewonnen then
  spr(spr_fahne, sp_x, sp_y - 8)
 elseif spiel_verloren then
  spr(spr_explosion, sp_x, sp_y)
 end

 if btn(0) or btn(1) or btn(2) then
  spr(spr_feuer, sp_x, sp_y + 8)
 end
end

function bewege_spieler()
 sp_uy = sp_uy + schwerkraft

 schiebe_spieler()

 sp_x = sp_x + sp_ux
 sp_y = sp_y + sp_uy

 bleib_im_bild()
end

function schiebe_spieler()
 if btn(0) then
  sp_ux = sp_ux - sp_schub
 end
 if btn(1) then
  sp_ux = sp_ux + sp_schub
 end
 if btn(2) then
  sp_uy = sp_uy - sp_schub
 end
 if btn(0) or btn(1) or btn(2) then
  sfx(0)
 end
end

function bleib_im_bild()
 if sp_x < 0 then
  sp_x = 0
  sp_ux = 0
 end
 if sp_x > 119 then
  sp_x = 119
  sp_ux = 0
 end
 if sp_y < 0 then
  sp_y = 0
  sp_uy = 0
 end
end

function ist_gelandet()
 spieler_links = flr(sp_x)
 spieler_rechts = flr(sp_x + 7)
 spieler_unten = flr(sp_y + 7)

 ist_langsam = sp_uy < 1

  for i_y = 0, 7 do
   ground = true
   for i_x = 0, 7 do
    pixel = pget(spieler_links + i_x, spieler_unten - i_y)
    if pixel == 13 then
     beende_spiel(false)
    end
    if i_y == 0 then
     if pixel != 10 then
      ground = false
     end
    else
     ground = false
    end
  end
  if ground and ist_langsam then
   beende_spiel(true)
  end
end

 if spieler_unten > 128 then
  beende_spiel(false)
 end
end

function beende_spiel(wert_1)
 spiel_verloren = true
 spiel_gewonnen = wert_1

 if spiel_gewonnen then
  sfx(1)
 else
  sfx(2)
 end
end
