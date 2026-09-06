# Álgebra relacional — Entrega 1

Las expresiones se construyen sobre las cinco relaciones del modelo inicial. Para
abreviar, se usan los siguientes nombres:

```text
E  = EDICION_MUNDIAL
S  = SELECCION
P  = PARTIDO
PP = PARTICIPACION_PARTIDO
ES = ESTADIO
```

Se utiliza `γ` para agregación, `ρ` para renombramiento, `σ` para selección, `π` para
proyección, `⋈` para junta, `−` para diferencia, `τ` para ordenamiento y `TOP5` como
operador extendido de las consultas de ranking. En álgebra clásica, `TOP5` se puede
interpretar como una operación de álgebra extendida equivalente a ordenar y conservar las
primeras cinco tuplas.

## Consulta 1 — Top 5 selecciones con más goles

Primero se restringe la edición y se relacionan las selecciones con sus participaciones:

```text
R1 ← σ_{E.anio = 2026}
      (E ⋈_{E.id_edicion = S.id_edicion} S
       ⋈_{S.id_seleccion = PP.id_seleccion ∧ S.id_edicion = PP.id_edicion} PP)

R2 ← γ_{S.id_seleccion, S.pais;
      SUM(PP.goles_marcados) → goles_favor}(R1)

R3 ← τ_{goles_favor DESC}(R2)

Resultado_1 ← TOP5(R3)
```

`σ` limita el año; `⋈` relaciona edición, selección y participación; `γ` obtiene el
total de goles y `TOP5` produce el ranking solicitado.

## Consulta 3 — Selecciones con mayor diferencia de gol

Se renombran dos copias de `PARTICIPACION_PARTIDO`. Cada participación de `A` se
relaciona con la otra participación del mismo partido en `B`; de esta forma se incluyen
tanto los partidos como local como los partidos como visitante:

```text
A ← ρ_{A}(PP)
B ← ρ_{B}(PP)

R1 ← σ_{E.anio = 2026 ∧
      A.id_partido = B.id_partido ∧
      A.id_seleccion ≠ B.id_seleccion}
      (E ⋈_{E.id_edicion = A.id_edicion} A
       ⋈_{A.id_partido = B.id_partido} B)

R2 ← γ_{A.id_edicion, A.id_seleccion;
      SUM(A.goles_marcados) − SUM(B.goles_marcados) → diferencia_goles}(R1)

R3 ← R2 ⋈_{R2.id_edicion = S.id_edicion ∧
           R2.id_seleccion = S.id_seleccion} S

R4 ← γ_{MAX(diferencia_goles) → maximo}(R3)

Resultado_3 ← σ_{diferencia_goles = maximo}(R3 × R4)
```

`ρ` permite usar la misma relación dos veces; la junta por `id_partido` forma cada
enfrentamiento; `γ` calcula la diferencia acumulada de cada selección y `MAX` identifica
el valor máximo.

## Consulta 7 — Selecciones invictas

Se obtienen por separado las selecciones que participaron y las que perdieron:

```text
R0 ← σ_{E.anio = 2026}
      (E ⋈_{E.id_edicion = PP.id_edicion} PP)

Participantes ← π_{PP.id_edicion, PP.id_seleccion}(R0)

Perdedoras ← π_{PP.id_edicion, PP.id_seleccion}
             (σ_{PP.resultado = 'PERDIO'}(R0))
```

```text
Invictas ← Participantes − Perdedoras

Resultado_7 ← Invictas ⋈_{Invictas.id_seleccion = S.id_seleccion ∧
                          Invictas.id_edicion = S.id_edicion} S
```

La diferencia elimina toda selección que aparezca en el conjunto de perdedoras. En SQL
esta operación se implementa con una subconsulta `NOT EXISTS`.

## Consulta 13 — Estadios con más de una fase

```text
R1 ← P ⋈_{P.id_estadio = ES.id_estadio ∧
         P.id_edicion = ES.id_edicion} ES

R2 ← γ_{ES.id_estadio, ES.nombre, P.id_edicion;
      COUNT(DISTINCT P.fase) → cantidad_fases}(R1)

Resultado_13 ← σ_{cantidad_fases > 1}(R2)
```

La agrupación por estadio y edición evita mezclar estadios homónimos de diferentes
ediciones. `COUNT(DISTINCT fase)` representa el `HAVING COUNT(DISTINCT fase) > 1` de la
consulta SQL.

## Correspondencia con SQL

| Consulta | Operadores principales | Implementación SQL |
|---|---|---|
| 1 | `σ`, `π`, `⋈`, `γ`, `τ`, `TOP5` | `VW_GOLEADORES_SEL`, `ORDER BY` y límite de cinco filas |
| 3 | `ρ`, `⋈`, `γ`, `MAX` | Autojunta lógica y agregación |
| 7 | `π`, `σ`, `−`, `⋈` | Subconsulta correlacionada `NOT EXISTS` |
| 13 | `⋈`, `γ`, `σ` | `GROUP BY` y `HAVING COUNT(DISTINCT ...) > 1` |
