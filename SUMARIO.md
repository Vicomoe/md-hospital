# 📑 TABLA DE CONTENIDOS / SUMARIO

## 🏥 MD-Hospital v3.0.1

### 📖 Índice Principal

- [🏥 MD-Hospital v3.0.1](#md-hospital-v301)
- [✨ Características](#características)
- [📦 Requisitos](#requisitos)
- [🚀 Instalación Rápida](#instalación-rápida)
- [⚙️ Configuración](#configuración)
- [📖 Estructura del Código](#estructura-del-código)
- [📝 Comandos Admin](#comandos-admin)
- [🔧 Archivos Principales](#archivos-principales)
- [🐛 Troubleshooting](#troubleshooting)
- [📝 Licencia](#licencia)

---

## ✨ Características

### Sistema de Muerte
- ⏱️ **Timer de respawn** configurable (120 segundos por defecto)
- 🔄 **Detector robusto** de muerte con validación
- 💫 **Animaciones y efectos** de transición

### Hospitales
- 🏥 **Múltiples hospitales** con ubicaciones personalizables
- 📍 **Blips en el mapa** para fácil localización
- 🚀 **Camas de revivir/curar** por hospital
- 👨‍⚕️ **NPCs paramédicos** con interacción ox_target

### Sistema Médico
- 💊 **Items médicos** completamente configurables
- 🛒 **Tienda médica** integrada con permisos por grado
- 📦 **Almacén de EMS** con sistema de stash
- ✅ **Validación** de estado (no usar items si estás muerto)

### Economía
- 💰 **Sistema de costos** por respawn configurable
- 💸 **Deducción automática** de dinero en efectivo
- 📊 **Tracking** de gastos en logs

### Administración
- 👮 **Comandos admin** (/heal, /revive, /kill)
- 🔐 **Permisos por grado** de trabajo
- 🚑 **Garaje de ambulancias** con vehículos personalizables
- 📋 **Boss Menu** para gestión de EMS

---

## 📦 Requisitos

### Framework y Dependencias Obligatorias
```
✅ FiveM - Framework FiveM actualizado
✅ QBCore - Framework QBCore v1.0+
✅ ox-lib - Librería ox (interfaz)
✅ ox-target - Sistema de interacción
✅ ox_inventory - Sistema de inventario
✅ origen_notify - Sistema de notificaciones
```

### Versión del Script
```
📌 Versión: 3.0.1
📌 Estado: Producción (Ready)
📌 Última actualización: Enero 2026
```

---

## 🚀 Instalación Rápida

### Paso 1: Descargar
```bash
git clone https://github.com/Vicomoe/md-hospital.git
```

### Paso 2: Colocar en Resources
```bash
cp -r md-hospital resources/
```

### Paso 3: Configurar Server
```
# En server.cfg, añade:
ensure md-hospital
```

### Paso 4: Reiniciar
```
/restart md-hospital
```

### Verificación
```
Deberías ver en console:
[MD-Hospital] ✅ Ready: stashes/shops registrados correctamente
```

---

## ⚙️ Configuración

### Editar Hospitales
Abre `config.lua`:

```lua
Config.Hospitals = {
    ['hospital_id'] = {
        name = 'Nombre del Hospital',
        respawn = { ... },      -- Camas de respawn
        pharmacy = { ... },     -- Tienda médica
        stash = { ... },        -- Almacén
        garage = { ... },       -- Garaje
        bossmenu = { ... },     -- Menú jefe
    }
}
```

### Editar Items Médicos
```lua
Config.MedicalItems = {
    { name = 'bandage', label = 'Vendaje', price = 1 },
    { name = 'medkit', label = 'Kit Médico', price = 1 },
    -- Añade más items aquí
}
```

### Editar Costos
```lua
Config.Costs = {
    respawn_fee = 25,  -- Costo de respawn en $
}
```

### Editar Tiempos
```lua
Config.RespawnTimer = {
    wait_time = 120,           -- Segundos antes de poder respawnear
    show_countdown = true,     -- Mostrar contador
}
```

---

## 📖 Estructura del Código

```
md-hospital/
│
├── 📄 fxmanifest.lua           ← Manifest del proyecto
├── 📄 config.lua               ← Configuración principal
├── 📄 README.md                ← Documentación
├── 📄 LICENSE                  ← Licencia MIT
│
├── 📁 client/                  ← Código del Cliente
│   ├── main.lua               ← Cliente principal (blips)
│   ├── death_system.lua       ← Sistema de muerte
│   ├── hospital_functions.lua ← Funciones de hospital
│   └── respawn_menu.lua       ← Menú de respawn/tienda
│
└── 📁 server/                  ← Código del Servidor
    ├── main.lua               ← Servidor principal
    ├── death_system.lua       ← Gestión de muertes
    ├── revive_system.lua      ← Sistema de revive
    └── medical_items.lua      ← Items médicos
```

---

## 📝 Comandos Admin

### Comando: /heal
```
Descripción: Curar completamente a un jugador
Sintaxis: /heal <id>
Ejemplo: /heal 5
Efecto: Restaura vida a 200 y armadura a 0
Permiso: admin
```

### Comando: /revive
```
Descripción: Revivir a un jugador muerto
Sintaxis: /revive <id>
Ejemplo: /revive 5
Efecto: Revive en el lugar donde murió
Permiso: admin
```

### Comando: /kill
```
Descripción: Matar a un jugador
Sintaxis: /kill <id>
Ejemplo: /kill 5
Efecto: Mata al jugador (inicia ciclo de muerte)
Permiso: admin
```

---

## 🔧 Archivos Principales

### fxmanifest.lua
```
Versión: 3.0.1
Dependencias: qb-core, ox-lib, ox-target, ox_inventory, origen_notify
Scripts: Client y Server
```

### config.lua
```
Configuración de:
- Hospitales (ubicaciones, camas, etc)
- Items médicos (name, label, precio)
- Tiempos (respawn timer)
- Costos (precio de respawn)
- Jobs (ambulancia)
```

### client/death_system.lua
```
Funcionalidad:
- Detector de muerte
- Timer de respawn
- Menú de hospitales
- Interacción con [E]
- Revive/respawn del jugador
```

### server/death_system.lua
```
Funcionalidad:
- Tracking de muertes
- Validación de timer
- Control de dinero
- Selección de hospital
- Logs de eventos
```

### server/revive_system.lua
```
Funcionalidad:
- Uso de camas (revive/heal)
- Revive por NPC
- Validaciones
- Notificaciones
```

### server/medical_items.lua
```
Funcionalidad:
- Registro de items usables
- Efecto de curación
- Validación de estado
- Notificaciones
```

---

## 🐛 Troubleshooting

### Problema: "Script ejecutó mal"
```
✓ Verifica que todas las dependencias están instaladas
✓ Revisa console para errores de Lua
✓ Asegúrate de que config.lua está correcto
```

### Problema: "Timer no funciona"
```
✓ Verifica que esperas 120 segundos
✓ Comprueba que está en server/death_system.lua
✓ Mira los logs en console
```

### Problema: "No aparecen los blips"
```
✓ En config.lua, verifica: blip.enable = true
✓ Reinicia el servidor
✓ Acércate a la ubicación del hospital
```

### Problema: "Los items no funcionan"
```
✓ Asegúrate de que ox_inventory está actualizado
✓ Verifica que el item existe en ox_inventory
✓ Revisa los logs en console
```

### Problema: "No tengo dinero para respawnear"
```
✓ Necesitas dinero en efectivo (cash)
✓ El costo está en config.lua: respawn_fee
✓ Si no tienes dinero, usa /heal desde admin
```

---

## 📊 Estadísticas

```
📈 Líneas de código: 1300+
📈 Logs añadidos: 20+
📈 Mejoras UX: 14+
📈 Errores corregidos: 9
📈 Documentación: Completa
```

---

## 🔄 Versiones

### v3.0.1 (Actual - Enero 2026)
- ✅ Correcciones críticas
- ✅ Mejora de logs
- ✅ Validaciones mejoradas
- ✅ Documentación completa

### v3.0.0
- Sistema de salud completo
- Múltiples hospitales
- NPCs paramédicos
- Tienda médica

---

## 📝 Licencia

Este proyecto está bajo **Licencia MIT**

Eres libre de:
- ✅ Usar comercialmente
- ✅ Modificar
- ✅ Distribuir
- ✅ Usar privadamente

Con la condición de:
- ⚠️ Mantener la licencia original

---

## 🤝 Contribuciones

Las contribuciones son bienvenidas:
1. Fork el repositorio
2. Crea una rama (`git checkout -b feature/mejora`)
3. Haz commit de tus cambios
4. Push a la rama (`git push origin feature/mejora`)
5. Abre un Pull Request

---

## 📞 Soporte

- **Issues** - Reporta bugs abriendo una issue
- **Discussiones** - Comparte ideas
- **Pull Requests** - Contribuciones bienvenidas

---

## 🎓 Recursos Útiles

- [QBCore Docs](https://github.com/qbcore-framework/qb-core)
- [ox-lib Docs](https://overextended.dev/)
- [FiveM Docs](https://docs.fivem.net/)

---

**Hecho con ❤️ para la comunidad de FiveM**

*Última actualización: Enero 2026*
