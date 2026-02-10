# -*- coding: utf-8 -*-

from odoo import models, fields, api
from odoo.exceptions import UserError, ValidationError


class CRAParteTrabajo(models.Model):
    _name = 'cra.parte.trabajo'
    _description = 'Parte de Trabajo CRA'
    _inherit = ['mail.thread', 'mail.activity.mixin']
    _order = 'fecha_parte desc, id desc'

    name = fields.Char(
        string='Número de Parte',
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
    
    fecha_parte = fields.Date(
        string='Fecha del Parte',
        required=True,
        default=fields.Date.today,
        tracking=True
    )
    
    tecnico_ids = fields.Many2many(
        'res.users',
        'cra_parte_tecnico_rel',
        'parte_id',
        'tecnico_id',
        string='Técnicos Asignados',
        tracking=True
    )
    
    tecnico_count = fields.Integer(
        string='Número de Técnicos',
        compute='_compute_tecnico_count',
        store=True
    )
    
    descripcion_trabajo = fields.Text(
        string='Descripción del Trabajo',
        required=True,
        tracking=True
    )
    
    tipo_trabajo = fields.Selection([
        ('instalacion', 'Instalación'),
        ('mantenimiento', 'Mantenimiento'),
        ('reparacion', 'Reparación'),
        ('revision', 'Revisión'),
        ('actualizacion', 'Actualización'),
    ], string='Tipo de Trabajo', required=True, tracking=True)
    
    estado = fields.Selection([
        ('borrador', 'Borrador'),
        ('en_proceso', 'En Proceso'),
        ('completado', 'Completado'),
        ('facturado', 'Facturado'),
    ], string='Estado', default='borrador', required=True, tracking=True)
    
    albaran_numero = fields.Char(
        string='Número de Albarán',
        tracking=True
    )
    
    # Comentado para evitar dependencia de account si no está instalado
    # factura_id = fields.Many2one(
    #     'account.move',
    #     string='Factura',
    #     tracking=True,
    #     domain=[('move_type', '=', 'out_invoice')]
    # )
    
    horas_trabajo = fields.Float(
        string='Horas de Trabajo',
        tracking=True
    )
    
    material_usado = fields.Text(
        string='Material Utilizado',
        tracking=True
    )
    
    firma_cliente = fields.Binary(
        string='Firma del Cliente',
        attachment=True
    )
    
    observaciones = fields.Text(
        string='Observaciones',
        tracking=True
    )
    
    dentro_garantia = fields.Boolean(
        string='Dentro de Garantía',
        default=False,
        tracking=True
    )
    
    incidencia_id = fields.Many2one(
        'cra.incidencia',
        string='Incidencia Relacionada',
        tracking=True
    )
    
    active = fields.Boolean(
        string='Activo',
        default=True
    )

    @api.depends('tecnico_ids')
    def _compute_tecnico_count(self):
        for record in self:
            record.tecnico_count = len(record.tecnico_ids)

    @api.constrains('tecnico_ids')
    def _check_tecnicos_duplicados(self):
        for record in self:
            if len(record.tecnico_ids) > 1:
                # Advertencia en lugar de bloqueo
                record.message_post(
                    body="⚠️ Atención: Este parte tiene más de un técnico asignado. "
                         "Verifica que esto sea correcto para evitar duplicidad.",
                    message_type='notification'
                )

    @api.model_create_multi
    def create(self, vals_list):
        for vals in vals_list:
            if vals.get('name', 'Nuevo') == 'Nuevo':
                vals['name'] = self.env['ir.sequence'].next_by_code('cra.parte.trabajo') or 'Nuevo'
        return super().create(vals_list)
    
    def action_iniciar(self):
        self.estado = 'en_proceso'
        
    def action_completar(self):
        if not self.fecha_parte:
            raise UserError('Debe especificar la fecha del parte antes de completarlo.')
        self.estado = 'completado'
        
    def action_facturar(self):
        self.estado = 'facturado'
        
    def action_reabrir(self):
        self.estado = 'en_proceso'
