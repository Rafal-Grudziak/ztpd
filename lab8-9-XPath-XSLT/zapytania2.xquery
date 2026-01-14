let $d := doc("zesp_prac.xml")
let $teams := $d/ZESPOLY/ROW
let $emps  := $d/ZESPOLY/ROW/PRACOWNICY/ROW

return
<RESULTS>

  <!-- Zadanie 31 -->
  <ZAD31_ROOT>{ $d/* }</ZAD31_ROOT>

  <!-- Zadanie 32 -->
  <ZAD32_NAZWISKA>{
    for $p in $emps
    return <NAZWISKO>{ data($p/NAZWISKO) }</NAZWISKO>
  }</ZAD32_NAZWISKA>

  <!-- Zadanie 33 -->
  <ZAD33_SYSTEMY_EKSPERCKIE>{
    for $p in $teams[NAZWA = "SYSTEMY EKSPERCKIE"]/PRACOWNICY/ROW
    return <NAZWISKO>{ data($p/NAZWISKO) }</NAZWISKO>
  }</ZAD33_SYSTEMY_EKSPERCKIE>

  <!-- Zadanie 34 -->
  <ZAD34_COUNT_TEAM_10>{
    count($emps[ID_ZESP = 10])
  }</ZAD34_COUNT_TEAM_10>

  <!-- Zadanie 35 -->
  <ZAD35_SZEF_100>{
    for $p in $emps[ID_SZEFA = 100]
    return <NAZWISKO>{ data($p/NAZWISKO) }</NAZWISKO>
  }</ZAD35_SZEF_100>

  <!-- Zadanie 36 -->
  <ZAD36_SUM_PLACA_POD_TEAM_BRZEZINSKI>{
    let $teamId := ($emps[NAZWISKO = "BRZEZINSKI"]/ID_ZESP)[1]
    return sum(
      for $p in $emps[ID_ZESP = $teamId]
      return xs:decimal(translate(data($p/PLACA_POD), ",", "."))
    )
  }</ZAD36_SUM_PLACA_POD_TEAM_BRZEZINSKI>

</RESULTS>
