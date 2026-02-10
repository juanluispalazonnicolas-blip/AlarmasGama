# -*- coding: utf-8 -*-
{
    'name': 'CRA Gestión',
    'version': '1.0.0',
    'category': 'Services',
    'summary': 'Gestión de Incidencias, Partes de Trabajo y Protocolos para CRA',
    'description': """
        Módulo personalizado para la gestión de Central Receptora de Alarmas
        =====================================================================
        
        Características principales:
        * Gestión completa de incidencias (AJAX, manuales, automáticas)
        * Control de partes de trabajo con asignación de técnicos
        * Protocolos personalizados por cliente
        * Gestión de garantías
        * Seguimiento de estados y prioridades
        * Integración con módulos de Odoo (contactos, mensajería)
        
        Diseñado específicamente para CRA Ibersegur
    """,
    'author': 'CRA Ibersegur',
    'website': 'https://www.ibersegur.com',
    'license': 'LGPL-3',
    'depends': [
        'base',
        'contacts',
        'mail',
    ],
    'data': [
        # Seguridad
        'security/cra_security.xml',
        'security/ir.model.access.csv',
        
        # Datos
        'data/sequences.xml',
        
        # Vistas
        'views/incidencia_views.xml',
        'views/parte_trabajo_views.xml',
        'views/protocolo_views.xml',
        'views/menus.xml',
    ],
    'demo': [],
    'installable': True,
    'application': True,
    'auto_install': False,
}
