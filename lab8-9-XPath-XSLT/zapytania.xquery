(: Zadanie 27 :)
for $k in doc("swiat.xml")/SWIAT/KRAJE/KRAJ
return
  <KRAJ>
    {$k/NAZWA}
    {$k/STOLICA}
  </KRAJ>


(: Zadanie 28 :)
for $k in doc("swiat.xml")/SWIAT/KRAJE/KRAJ
where starts-with($k/NAZWA, "A")
return
  <KRAJ>
    {$k/NAZWA}
    {$k/STOLICA}
  </KRAJ>


(: Zadanie 29 :)
for $k in doc("swiat.xml")/SWIAT/KRAJE/KRAJ
where substring($k/NAZWA, 1, 1) = substring($k/STOLICA, 1, 1)
return
  <KRAJ>
    {$k/NAZWA}
    {$k/STOLICA}
  </KRAJ>


(: Zadanie 30 :)
doc("swiat.xml")//KRAJ
