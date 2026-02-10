# INFORME DE AUDITORÍA — PROTOCOLOS GAMA SEGURIDAD

**Fecha de auditoría**: 10 de febrero de 2026  
**Documento auditado**: PROTOCOLOS GAMA SEGURIDAD.pdf (203 páginas)  
**Auditor**: Análisis automatizado con revisión total del documento  

---

## 1. Resumen General

| Métrica | Valor |
|---|---|
| Páginas totales | 203 |
| Clientes/instalaciones documentados | ~130+ |
| Clientes activos | ~125+ |
| Clientes dados de baja (BAJA) | 5 |
| Grupos empresariales principales | 11 |
| Credenciales expuestas | 7 instancias |
| Erratas encontradas | 15+ |
| Entradas con información temporal expirada | 4 |
| Bloques de protocolo duplicados | 4 tipos × múltiples clientes |

---

## 2. 🔴 Credenciales Expuestas en Texto Plano

**Riesgo: ALTO** — Cualquier persona con acceso al PDF puede ver usuarios y contraseñas de sistemas de videovigilancia.

| # | Cliente | Página | Usuario | Contraseña |
|---|---|---|---|---|
| 1 | Residencial Agridulce | 63 | admin | gama2589 |
| 2 | Villa Plata | 71 | admin | gama2589 |
| 3 | Plásticos del Segura Vicálvaro | 76 | admin | Gama2589 |
| 4 | Campo Solar La Serrana | 94 | admin | Gama2589 |
| 5 | Replay Sangonera La Verde | 124 | admin | Gama2288 |
| 6 | Las Torres (Salón Zass) | 135 | admin | 11001100SA |
| 7 | Dealer | 178 | admin | pepito |

**Observación adicional**: La contraseña `gama2589` / `Gama2589` se reutiliza en al menos 4 clientes distintos, aumentando el riesgo si una es comprometida.

**Recomendación**: Implementar un gestor de contraseñas centralizado y eliminar las credenciales del documento de protocolos. Cambiar contraseñas reutilizadas.

---

## 3. 🟡 Clientes Dados de Baja (BAJA)

Estos clientes siguen documentados en el cuerpo principal pese a estar marcados como BAJA:

| # | Cliente | Abonado | Página | Notas |
|---|---|---|---|---|
| 1 | Grupo Empresarial Marevents — Gasolinera Los Llanos 2 | 8C4B | 79 | Marcado "BAJA" |
| 2 | Campo Solar Las Ramblas | 14996 | 92 | Marcado "BAJA" |
| 3 | Campo Solar Espartosa | 15158 | 93 | Marcado "BAJA" |
| 4 | Campo Solar La Serrana | 15212 | 94 | Marcado "BAJA" |
| 5 | Esteve Hita Heladerías | E629 | 110 | Marcado "BAJA" |

**Acción**: Mover a apéndice "Clientes Históricos".

---

## 4. 🟡 Entradas con Información Temporal Expirada o Dudosa

| # | Cliente | Página | Detalle | Estado |
|---|---|---|---|---|
| 1 | Colegio Gabriel Pérez Cárcel | 103 | Servicio con fin: 29/08/2023 | ⚠️ EXPIRADO |
| 2 | Edificio Victoria | 99 | Servicio temporal julio-agosto (¿vigente?) | ⚠️ VERIFICAR |
| 3 | "777" Boulevard | 127 | "ACTUALMENTE EN AVERÍA (05/10/2023)" | ⚠️ VERIFICAR |
| 4 | Salón Babel | 128 | "Ajax (sin conexión), Ossia PC2 (No está configurado)" | ⚠️ VERIFICAR |
| 5 | Ártico Capital Sangonera | 96 | "06/06/2025 – EDIFICIO ESTÁ HABITADO, NO HAY ALARMA SÓLO GRABACIÓN" | 🔵 INFO |

---

## 5. 🟡 Erratas y Errores Tipográficos

| # | Página(s) | Texto erróneo | Corrección | Tipo |
|---|---|---|---|---|
| 1 | Múltiples | "Xtraliss" | "Xtralis" | Nombre producto |
| 2 | 136, 166, 167 | "SmatPSS" | "SmartPSS" | Nombre producto |
| 3 | 94 | "no molesar" | "no molestar" | Errata |
| 4 | 138, 140, 149 | "armado/desrmado" | "armado/desarmado" | Errata |
| 5 | 92, 94 | "automaticos" / "automatico" | "automáticos" / "automático" | Tilde faltante |
| 6 | Múltiples (~40) | "policia" | "policía" | Tilde faltante |
| 7 | 111 | "Policia Local: 062" | 062 = Guardia Civil — posible error | Error datos |
| 8 | 111 | "Policia Nacional: 061" | 061 = Emergencias sanitarias — posible error | Error datos |
| 9 | 87 | "Guardia Civil: 968 23 45 65" como "Policía Nacional" | Confusión cuerpo policial | Error datos |
| 10 | 92 | "SAMRTPSS" | "SmartPSS" | Errata |
| 11 | 113 | Gregorio y Antonio con mismo teléfono: 609 664 367 | ¿Correcto? Verificar | Posible error |

---

## 6. 🟢 Formato Inconsistente de Números de Teléfono

Se han detectado **3 formatos distintos** de teléfonos a lo largo del documento:

| Formato | Ejemplo | Frecuencia |
|---|---|---|
| `XXX XX XX XX` | 968 23 45 65 | ~60% |
| `XXX XXX XXX` | 606 598 493 | ~30% |
| `XXX XX XX XX` (fijo) + `XXX XXX XXX` (móvil) | Mixto en misma ficha | ~10% |

**Acción**: Unificar todos a formato `XXX XXX XXX`.

---

## 7. 🟢 Campos Faltantes o Incompletos

### Clientes sin número de abonado:
- Villa Plata (p.71)
- Edificio Victoria (p.99)
- Oficinas Puente Tocinos - Recreativos Carmona (p.162)
- Grupo Magani – Catral (p.185)
- Grupo Magani – Callosa (p.187)

### Clientes sin enlace GPS/Maps:
- Sermaco Levante Valencia (p.67) — solo dirección textual
- Sermaco Levante Barcelona (p.67) — solo dirección textual
- Replay Aljucer (p.125) — tiene enlace pero verificar
- Gabriel Fernández Pardo (p.108) — sin enlace Maps

### Clientes sin ruta a Ficha Técnica:
Aproximadamente el **60%** de los clientes no tienen referenciada la ruta a su ficha técnica en el servidor `\\GAMASVR\`.

### Clientes sin especificación de horario ACUDA:
- Salón Babel (p.128) — tiene ACUDA pero ¿horario?
- Solvia Servicios Inmobiliarios (p.109) — sin mención de ACUDA
- Gabriel Fernández Pardo (p.108) — ACUDA sin horario claro

---

## 8. 🟢 Bloques de Protocolo Duplicados

Se identifican **4 tipos de protocolo estándar** que se repiten de forma casi idéntica:

### Tipo A: Protocolo Davantis/Xtralis + Cámaras + ACUDA (~30+ clientes)
> "Cuando salte la analítica [Davantis/Xtraliss] o la alarma comprobar por cámaras en [programa]. En caso de no estar seguros, tenemos servicio ACUDA. Llamar siempre en caso de alarma confirmada a la policía y cliente, en este orden."

### Tipo B: Protocolo Ajax + Fotosensores + Ocupación (~15+ clientes)
> "En caso de salto de alarma del sistema Ajax se verificará la alarma a través de los fotosensores de los que disponemos. En caso de que sea intrusión de ocupación, se enviará al servicio de acuda junto con la FCSE que correspondan y al cliente, en este orden."

### Tipo C: Protocolo Campos Solares (~8 campos)
> "En caso de pérdida de alimentación del sistema de más de 15 min., llamar a los responsables"
> + Informe diario 10h + Revisión armado 15h + Notificación WhatsApp

### Tipo D: Protocolo Salones de Juego con Cañón (~25+ salones)
> "Cuando haya un salto de [Xtraliss/alarma] comprobar por cámaras en [programa]. Llamar en cualquier caso de alarma confirmada a la policía y al cliente, en este orden. Hay que tener en cuenta de que disponemos de cañón de humo [y sirena/strobo] en Ajax."

---

## 9. 🟢 Directorio de Llaves ACUDA — Inventario Reconstruido

| Llave | Cliente | Dirección |
|---|---|---|
| Nº1 | Rointe | Pol. Ind. Vicente Antolinos, Santomera |
| Nº3 | Villa Plata | Urb. Villa-Plata, El Esparragal |
| Nº5 | Recreativos Carmona Blanca | Ctra. Jumilla KM 3.5, Blanca |
| Nº9 | Proypisa – Polaris World | San Javier |
| Nº13 | ITV DFM Cabezo Cortado | Pol. Ind. Cabezo Cortado, Molina de Segura |
| Nº18 | Reciclajes Elda | Camino Fructuosos 31, El Esparragal |
| Nº19 | Sermaco Levante Cabezo Torres | Av. Alto Atalayas 250 |
| Nº20 | Ártico Capital Espinardo | C/Quevedo 7, Espinardo |
| Nº21 | Disfrimur Sangonera A7 | A7 KM 584, Sangonera La Seca |
| Nº22 | Plásticos del Segura Puente Tocinos | Carril Bernabeles, Puente Tocinos |
| Nº23 | DFM Induráin | Av. Miguel Induráin, Murcia |
| Nº24 | DFM Lorca | Ctra. Granada KM 266, Lorca |
| Nº25 | Artemur – El Retal | Av. M. Cervantes 114 |
| Nº26 | Ártico Capital Torreagüera | C/Perillo 3 y 5, Torreagüera |
| Nº28 | Campo Solar de Ojós | Ctra. Campos del Río KM 1.4, Ojós |
| Nº29 | Campo Solar Fenazar Captasol | Ctra. RM-11 KM 8, El Fenazar |
| Nº30 | Campos Solares Mediterráneo Jumilla 1 | Jumilla |
| Nº31 | Planta Solar Yecla 1 | Paraje Rambla del Tomate, Yecla |
| Nº32 | Solgenera Jumilla 2 | Paraje el Prado, Jumilla |
| Nº36 | Planta Solar Yecla 2 | Camino Casa Berbajo, Yecla |
| Nº39 | Iproal Fabricante | C/Laderas 83, El Esparragal |
| Nº41 | Edificio Murillo (Aljucer) | C/Libertad 12, Aljucer |
| Nº42 | Soluciona Gestión La Alberca | C/Lope de Vega 27, La Alberca |
| Nº43 | Almacén Sardineros | C/Vereda de la Cueva 4, Monteagudo |
| Nº44 | Plásticos Segura Beniaján (Nave Chinos) | C/Mayor Villanueva 53, Beniaján |
| Nº45 | Elcom Air | Ctra. CV-870 Orihuela-Abanilla |
| Nº46 | Ángel Marcos Vivancos | C/Santa Ana 11, El Esparragal |
| Nº47 | Ártico Capital Sangonera La Seca | Av. Constitución 7, Sangonera |
| Nº48 | Ángel Luis Orenes Rodríguez | Pza. Santa Isabel 12, Murcia |
| Nº50 | Cooperativa Eléctrica Catralense | Camino Estación, Catral |
| Nº51 | Campo Solar Las Ramblas / Espartosa / La Serrana | Cieza (compartida) |
| Nº52 | Residencial Agridulce | Urb. Mirador Agridulce, Espinardo |
| Nº53 | Soluciona Gestión Monteagudo | C/Martínez Costa 4, Monteagudo |
| Nº55 | Soluciona Gestión Alhama | C/Lepanto 2, Alhama de Murcia |
| Nº56 | Campo Solar Fuente Álamo | Fuente Álamo |

---

## 10. Recomendaciones Generales

1. **Revisión trimestral**: Establecer calendario de revisión del documento cada 3 meses
2. **Control de versiones**: Usar un sistema de versionado (ej: fecha en nombre de archivo o Git)
3. **Gestor de contraseñas**: Migrar credenciales a una herramienta segura
4. **Protocolos tipo**: Crear plantillas de protocolo estándar referenciables por código
5. **Campo "Última actualización"**: Añadir fecha de última revisión a cada ficha
6. **Formato unificado**: Aplicar plantilla estándar a todas las fichas de cliente
7. **Directorio centralizado**: Teléfonos de emergencia por municipio en sección separada

---

*Fin del informe de auditoría*
