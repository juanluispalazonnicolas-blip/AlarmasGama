# -*- coding: utf-8 -*-

from odoo import models, fields, api
from datetime import date


class CRAProtocolo(models.Model):
    _name = 'cra.protocolo'
    _description = 'Protocolo de Cliente CRA'
    _inherit = ['mail.thread', 'mail.activity.mixin']
    _order = 'nivel_criticidad desc, name'

    name = fields.Char(
        string='Nombre del Protocolo',
        required=True,
        tracking=True
    )
    
    cliente_id = fields.Many2one(
        'res.partner',
        string='Cliente',
        required=True,
        tracking=True,
        domain=[('customer_rank', '>', 0)]
    )
    
    tipo_servicio = fields.Selection([
        ('salon_juego', 'Salón de Juego'),
        ('campo_solar', 'Campo Solar'),
        ('empresa', 'Empresa'),
        ('residencial', 'Residencial'),
        ('otros', 'Otros'),
    ], string='Tipo de Servicio', required=True, tracking=True)
    
    checklist = fields.Html(
        string='Lista de Verificación',
        tracking=True,
        help='Checklist de tareas a realizar durante la atención'
    )
    
    horario_limpieza = fields.Char(
        string='Horario de Limpieza',
        tracking=True
    )
    
    horario_guardias = fields.Char(
        string='Horario de Guardias',
        tracking=True
    )
    
    acciones_incidencia = fields.Text(
        string='Acciones por Incidencia',
        tracking=True,
        help='Procedimiento a seguir cuando hay una incidencia'
    )
    
    dentro_garantia = fields.Boolean(
        string='Dentro de Garantía',
        compute='_compute_dentro_garantia',
        store=True,
        tracking=True
    )
    
    fecha_inicio_garantia = fields.Date(
        string='Inicio de Garantía',
        tracking=True
    )
    
    fecha_fin_garantia = fields.Date(
        string='Fin de Garantía',
        tracking=True
    )
    
    dias_restantes_garantia = fields.Integer(
        string='Días Restantes de Garantía',
        compute='_compute_dias_restantes_garantia'
    )
    
    nivel_criticidad = fields.Selection([
        ('normal', 'Normal'),
        ('prioritario', 'Prioritario'),
        ('critico', 'Crítico'),
    ], string='Nivel de Criticidad', default='normal', required=True, tracking=True)
    
    contacto_emergencia = fields.Char(
        string='Contacto de Emergencia',
        tracking=True
    )
    
    telefono_emergencia = fields.Char(
        string='Teléfono de Emergencia',
        tracking=True
    )
    
    notas_especiales = fields.Text(
        string='Notas Especiales',
        tracking=True
    )
    
    activo = fields.Boolean(
        string='Activo',
        default=True,
        tracking=True
    )
    
    active = fields.Boolean(
        string='Archivado',
        default=True
    )

    @api.depends('fecha_inicio_garantia', 'fecha_fin_garantia')
    def _compute_dentro_garantia(self):
        today = date.today()
        for record in self:
            if record.fecha_inicio_garantia and record.fecha_fin_garantia:
                record.dentro_garantia = (
                    record.fecha_inicio_garantia <= today <= record.fecha_fin_garantia
                )
            else:
                record.dentro_garantia = False

    @api.depends('fecha_fin_garantia')
    def _compute_dias_restantes_garantia(self):
        today = date.today()
        for record in self:
            if record.fecha_fin_garantia:
                delta = record.fecha_fin_garantia - today
                record.dias_restantes_garantia = delta.days if delta.days > 0 else 0
            else:
                record.dias_restantes_garantia = 0

    @api.onchange('cliente_id')
    def _onchange_cliente_id(self):
        if self.cliente_id:
            self.name = f"Protocolo - {self.cliente_id.name}"
