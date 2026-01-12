# 🏥 MD-Hospital v3.0.1

**Sistema completo de salud para QBCore FiveM**

![Version](https://img.shields.io/badge/version-3.0.1-blue)
![Status](https://img.shields.io/badge/status-production-green)

## 📋 Características

- ⏱️ **Timer de respawn** configurable (120 segundos por defecto)
- 🏥 **Múltiples hospitales** con ubicaciones personalizables
- 💊 **Sistema de items médicos** integrado
- 🚑 **Garaje de ambulancias** con spawn de vehículos
- 👨‍⚕️ **NPCs paramédicos** con interacción
- 💰 **Sistema de costos** por respawn
- 🛒 **Tienda médica** integrada
- 📦 **Almacén de EMS** con permisos por grado

## 📦 Requisitos

- **FiveM** - Framework FiveM
- **QBCore** - Framework QBCore
- **ox-lib** - Librería ox
- **ox-target** - Sistema de interacción
- **ox_inventory** - Sistema de inventario
- **origen_notify** - Sistema de notificaciones

## 🚀 Instalación

1. **Clona el repositorio**
```bash
git clone https://github.com/Vicomoe/md-hospital.git
Copia en tu carpeta resources

bash
cp -r md-hospital /path/to/resources/
Añade a tu server.cfg

text
ensure md-hospital
Reinicia tu servidor

text
/restart md-hospital
⚙️ Configuración
Edita el archivo config.lua para personalizar:

Ubicaciones de hospitales - Añade o modifica hospitales

Items médicos - Define los items disponibles

Costos de respawn - Configura el precio del respawn

Tiempos - Ajusta los timers según necesites

Permisos - Define qué grades pueden usar cada cosa

Ejemplo de Hospital
lua
['north'] = {
    name = 'SANTUARIO',
    paramedic = { model = 's_m_m_scientist_01', pos = vector4(...) },
    respawn = { { bedPoint = vector4(...), bedType = 'revive' } },
    pharmacy = { ['shop'] = { grade = 4, items = Config.MedicalItems } },
    -- ... más configuración
}
📖 Comandos Admin
lua
/heal <id>      -- Curar completamente a un jugador
/revive <id>    -- Revivir a un jugador
/kill <id>      -- Matar a un jugador
🔧 Estructura del Código
text
md-hospital/
├── fxmanifest.lua              -- Manifest del proyecto
├── config.lua                  -- Configuración principal
├── client/
│   ├── main.lua               -- Cliente principal
│   ├── death_system.lua       -- Sistema de muerte
│   ├── hospital_functions.lua -- Funciones de hospital
│   └── respawn_menu.lua       -- Menú de respawn
└── server/
    ├── main.lua               -- Servidor principal
    ├── death_system.lua       -- Gestión de muertes
    ├── revive_system.lua      -- Sistema de revive
    └── medical_items.lua      -- Items médicos
🐛 Reportar Errores
Si encuentras bugs:

Abre una Issue en este repositorio

Describe el problema con detalle

Incluye logs si es posible

📝 Licencia
Este proyecto está bajo licencia MIT. Eres libre de:

Usar

Modificar

Distribuir

Usar con fines comerciales

Bajo la condición de que incluyas la licencia original.

👨‍💻 Autor
Vicomoe - Desarrollador de scripts FiveM

🙏 Agradecimientos
QBCore Team por el framework

ox-lib Team por las librerías

La comunidad de FiveM

📞 Soporte
Issues - Reporta bugs abierto una issue

Discussiones - Comparte ideas y sugerencias

Pull Requests - Contribuciones bienvenidas

Hecho con ❤️ para la comunidad de FiveM
