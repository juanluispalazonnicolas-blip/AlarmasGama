# -*- coding: utf-8 -*-

from odoo import models, fields, api
from odoo.exceptions import ValidationError


class CRAIncidencia(models.Model):
    _name = 'cra.incidencia'
    _description = 'Incidencia CRA'
    _inherit = ['mail.thread', 'mail.activity.mixin']
    _order = 'fecha_incidencia desc, id desc'

    name = fields.Char(
        string='Número de Incidencia',
        required=True,
        copy=False,
        readonly=True,
        default='Nuevo',
        tracking=True
    )
    
    cliente_id = fields.Many2one(
        'res.partner',
        string='Cliente',
        required=True,
        tracking=True,
        domain=[('customer_rank', '>', 0)]
    )
    
    fecha_incidencia = fields.Datetime(
        string='Fecha de Incidencia',
        required=True,
        default=fields.Datetime.now,
        tracking=True
    )
    
    tipo_incidencia = fields.Selection([
        ('no_video', 'No Video'),
        ('fallo_cam', 'Fallo Cámara'),
        ('exceso_saltos', 'Exceso de Saltos'),
        ('salto_alarma', 'Salto de Alarma'),
        ('aviso_tecnico', 'Aviso Técnico'),
        ('otros', 'Otros'),
    ], string='Tipo de Incidencia', required=True, tracking=True)
    
    origen = fields.Selection([
        ('ajax', 'AJAX'),
        ('manual', 'Manual'),
        ('automatico', 'Automático'),
        ('sistema_visionado', 'Sistema de Visionado'),
    ], string='Origen', required=True, default='manual', tracking=True)
    
    descripcion = fields.Text(
        string='Descripción',
        tracking=True
    )
    
    estado = fields.Selection([
        ('borrador', 'Borrador'),
        ('en_curso', 'En Curso'),
        ('resuelto', 'Resuelto'),
        ('cerrado', 'Cerrado'),
    ], string='Estado', default='borrador', required=True, tracking=True)
    
    prioridad = fields.Selection([
        ('baja', 'Baja'),
        ('normal', 'Normal'),
        ('alta', 'Alta'),
        ('critica', 'Crítica'),
    ], string='Prioridad', default='normal', required=True, tracking=True)
    
    salon_afectado = fields.Char(
        string='Salón Afectado',
        tracking=True
    )
    
    responsable_id = fields.Many2one(
        'res.users',
        string='Responsable',
        tracking=True,
        default=lambda self: self.env.user
    )
    
    fecha_resolucion = fields.Datetime(
        string='Fecha de Resolución',
        tracking=True
    )
    
    notas_resolucion = fields.Text(
        string='Notas de Resolución',
        tracking=True
    )
    
    parte_trabajo_ids = fields.One2many(
        'cra.parte.trabajo',
        'incidencia_id',
        string='Partes de Trabajo Relacionados'
    )
    
    active = fields.Boolean(
        string='Activo',
        default=True
    )

    @api.model_create_multi
    def create(self, vals_list):
        for vals in vals_list:
            if vals.get('name', 'Nuevo') == 'Nuevo':
                vals['name'] = self.env['ir.sequence'].next_by_code('cra.incidencia') or 'Nuevo'
        return super().create(vals_list)
    
    def action_iniciar(self):
        self.estado = 'en_curso'
        
    def action_resolver(self):
        self.estado = 'resuelto'
        self.fecha_resolucion = fields.Datetime.now()
        
    def action_cerrar(self):
        self.estado = 'cerrado'
        
    def action_reabrir(self):
        self.estado = 'en_curso'
        self.fecha_resolucion = False
