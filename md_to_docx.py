import zipfile
import os
import re
import io

PYTHON = r'C:\Users\Juanlu\AppData\Local\Programs\Python\Python312\python.exe'
BASE_DIR = r'c:\Users\Juanlu\Desktop\ALARMAS GAMA'

def escape_xml(text):
    return text.replace('&', '&amp;').replace('<', '&lt;').replace('>', '&gt;').replace('"', '&quot;')

def md_to_docx_xml(md_text):
    """Convert markdown text to Office Open XML paragraphs."""
    paragraphs = []
    lines = md_text.split('\n')
    in_table = False
    table_rows = []
    
    for line in lines:
        stripped = line.strip()
        
        # Skip empty lines
        if not stripped:
            if in_table and table_rows:
                paragraphs.append(build_table_xml(table_rows))
                table_rows = []
                in_table = False
            paragraphs.append('<w:p><w:r><w:t xml:space="preserve"> </w:t></w:r></w:p>')
            continue
        
        # Table rows
        if stripped.startswith('|') and stripped.endswith('|'):
            # Skip separator rows like |---|---|
            if re.match(r'^\|[\s\-|:]+\|$', stripped):
                in_table = True
                continue
            cells = [c.strip() for c in stripped.split('|')[1:-1]]
            table_rows.append(cells)
            in_table = True
            continue
        elif in_table and table_rows:
            paragraphs.append(build_table_xml(table_rows))
            table_rows = []
            in_table = False
        
        # Horizontal rules
        if stripped == '---' or stripped == '***':
            paragraphs.append('<w:p><w:pPr><w:pBdr><w:bottom w:val="single" w:sz="6" w:space="1" w:color="auto"/></w:pBdr></w:pPr></w:p>')
            continue
        
        # Headers
        if stripped.startswith('#'):
            level = len(stripped.split(' ')[0])
            text = stripped.lstrip('#').strip()
            style = f'Heading{min(level, 4)}'
            text = re.sub(r'\*\*(.*?)\*\*', r'\1', text)
            text = re.sub(r'\[(.*?)\]\(.*?\)', r'\1', text)
            paragraphs.append(f'<w:p><w:pPr><w:pStyle w:val="{style}"/></w:pPr><w:r><w:rPr><w:b/></w:rPr><w:t xml:space="preserve">{escape_xml(text)}</w:t></w:r></w:p>')
            continue
        
        # Blockquotes
        if stripped.startswith('>'):
            text = stripped.lstrip('>').strip()
            text = clean_inline(text)
            paragraphs.append(f'<w:p><w:pPr><w:ind w:left="720"/></w:pPr><w:r><w:rPr><w:i/><w:color w:val="555555"/></w:rPr><w:t xml:space="preserve">{escape_xml(text)}</w:t></w:r></w:p>')
            continue
        
        # List items
        if stripped.startswith('- ') or stripped.startswith('* ') or re.match(r'^\d+\.\s', stripped):
            if re.match(r'^\d+\.\s', stripped):
                text = re.sub(r'^\d+\.\s+', '', stripped)
            else:
                text = stripped[2:]
            runs = build_runs(text)
            paragraphs.append(f'<w:p><w:pPr><w:ind w:left="360" w:hanging="360"/></w:pPr>{runs}</w:p>')
            continue
        
        # Normal paragraph with inline formatting
        runs = build_runs(stripped)
        paragraphs.append(f'<w:p>{runs}</w:p>')
    
    # Flush remaining table
    if in_table and table_rows:
        paragraphs.append(build_table_xml(table_rows))
    
    return '\n'.join(paragraphs)

def clean_inline(text):
    text = re.sub(r'\*\*(.*?)\*\*', r'\1', text)
    text = re.sub(r'\*(.*?)\*', r'\1', text)
    text = re.sub(r'\[(.*?)\]\(.*?\)', r'\1', text)
    text = re.sub(r'`(.*?)`', r'\1', text)
    return text

def build_runs(text):
    """Build XML runs with bold/italic support."""
    runs = []
    parts = re.split(r'(\*\*.*?\*\*|\*.*?\*|`.*?`|\[.*?\]\(.*?\))', text)
    for part in parts:
        if not part:
            continue
        if part.startswith('**') and part.endswith('**'):
            inner = part[2:-2]
            runs.append(f'<w:r><w:rPr><w:b/></w:rPr><w:t xml:space="preserve">{escape_xml(inner)}</w:t></w:r>')
        elif part.startswith('*') and part.endswith('*') and not part.startswith('**'):
            inner = part[1:-1]
            runs.append(f'<w:r><w:rPr><w:i/></w:rPr><w:t xml:space="preserve">{escape_xml(inner)}</w:t></w:r>')
        elif part.startswith('`') and part.endswith('`'):
            inner = part[1:-1]
            runs.append(f'<w:r><w:rPr><w:rFonts w:ascii="Courier New" w:hAnsi="Courier New"/><w:sz w:val="20"/></w:rPr><w:t xml:space="preserve">{escape_xml(inner)}</w:t></w:r>')
        elif part.startswith('[') and '](' in part:
            link_text = re.sub(r'\[(.*?)\]\(.*?\)', r'\1', part)
            runs.append(f'<w:r><w:rPr><w:color w:val="0563C1"/><w:u w:val="single"/></w:rPr><w:t xml:space="preserve">{escape_xml(link_text)}</w:t></w:r>')
        else:
            runs.append(f'<w:r><w:t xml:space="preserve">{escape_xml(part)}</w:t></w:r>')
    return ''.join(runs)

def build_table_xml(rows):
    """Build a simple Word table from rows of cells."""
    if not rows:
        return ''
    
    num_cols = max(len(r) for r in rows)
    col_width = 9000 // num_cols
    
    grid = ''.join(f'<w:gridCol w:w="{col_width}"/>' for _ in range(num_cols))
    
    table_xml = f'<w:tbl><w:tblPr><w:tblStyle w:val="TableGrid"/><w:tblW w:w="9000" w:type="dxa"/><w:tblBorders><w:top w:val="single" w:sz="4" w:space="0" w:color="auto"/><w:left w:val="single" w:sz="4" w:space="0" w:color="auto"/><w:bottom w:val="single" w:sz="4" w:space="0" w:color="auto"/><w:right w:val="single" w:sz="4" w:space="0" w:color="auto"/><w:insideH w:val="single" w:sz="4" w:space="0" w:color="auto"/><w:insideV w:val="single" w:sz="4" w:space="0" w:color="auto"/></w:tblBorders></w:tblPr><w:tblGrid>{grid}</w:tblGrid>'
    
    for i, row in enumerate(rows):
        row_xml = '<w:tr>'
        for j in range(num_cols):
            cell_text = row[j] if j < len(row) else ''
            cell_text = clean_inline(cell_text)
            if i == 0:  # Header row bold
                row_xml += f'<w:tc><w:tcPr><w:shd w:fill="D9E2F3" w:val="clear"/></w:tcPr><w:p><w:r><w:rPr><w:b/><w:sz w:val="18"/></w:rPr><w:t xml:space="preserve">{escape_xml(cell_text)}</w:t></w:r></w:p></w:tc>'
            else:
                row_xml += f'<w:tc><w:p><w:r><w:rPr><w:sz w:val="18"/></w:rPr><w:t xml:space="preserve">{escape_xml(cell_text)}</w:t></w:r></w:p></w:tc>'
        row_xml += '</w:tr>'
        table_xml += row_xml
    
    table_xml += '</w:tbl>'
    return table_xml

def create_docx(md_content, output_path, title="Documento"):
    """Create a .docx file from markdown content using raw XML."""
    
    body_xml = md_to_docx_xml(md_content)
    
    # [Content_Types].xml
    content_types = '''<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<Types xmlns="http://schemas.openxmlformats.org/package/2006/content-types">
  <Default Extension="rels" ContentType="application/vnd.openxmlformats-package.relationships+xml"/>
  <Default Extension="xml" ContentType="application/xml"/>
  <Override PartName="/word/document.xml" ContentType="application/vnd.openxmlformats-officedocument.wordprocessingml.document.main+xml"/>
  <Override PartName="/word/styles.xml" ContentType="application/vnd.openxmlformats-officedocument.wordprocessingml.styles+xml"/>
</Types>'''
    
    # _rels/.rels
    rels = '''<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<Relationships xmlns="http://schemas.openxmlformats.org/package/2006/relationships">
  <Relationship Id="rId1" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/officeDocument" Target="word/document.xml"/>
</Relationships>'''
    
    # word/_rels/document.xml.rels
    doc_rels = '''<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<Relationships xmlns="http://schemas.openxmlformats.org/package/2006/relationships">
  <Relationship Id="rId1" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/styles" Target="styles.xml"/>
</Relationships>'''
    
    # word/styles.xml
    styles = '''<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<w:styles xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main">
  <w:docDefaults>
    <w:rPrDefault><w:rPr><w:rFonts w:ascii="Calibri" w:hAnsi="Calibri"/><w:sz w:val="22"/></w:rPr></w:rPrDefault>
  </w:docDefaults>
  <w:style w:type="paragraph" w:styleId="Heading1"><w:name w:val="heading 1"/><w:pPr><w:spacing w:before="360" w:after="120"/></w:pPr><w:rPr><w:rFonts w:ascii="Calibri" w:hAnsi="Calibri"/><w:b/><w:sz w:val="36"/><w:color w:val="1F3864"/></w:rPr></w:style>
  <w:style w:type="paragraph" w:styleId="Heading2"><w:name w:val="heading 2"/><w:pPr><w:spacing w:before="240" w:after="80"/></w:pPr><w:rPr><w:rFonts w:ascii="Calibri" w:hAnsi="Calibri"/><w:b/><w:sz w:val="30"/><w:color w:val="2E75B6"/></w:rPr></w:style>
  <w:style w:type="paragraph" w:styleId="Heading3"><w:name w:val="heading 3"/><w:pPr><w:spacing w:before="200" w:after="60"/></w:pPr><w:rPr><w:rFonts w:ascii="Calibri" w:hAnsi="Calibri"/><w:b/><w:sz w:val="26"/><w:color w:val="404040"/></w:rPr></w:style>
  <w:style w:type="paragraph" w:styleId="Heading4"><w:name w:val="heading 4"/><w:pPr><w:spacing w:before="160" w:after="40"/></w:pPr><w:rPr><w:rFonts w:ascii="Calibri" w:hAnsi="Calibri"/><w:b/><w:i/><w:sz w:val="24"/><w:color w:val="404040"/></w:rPr></w:style>
  <w:style w:type="table" w:styleId="TableGrid"><w:name w:val="Table Grid"/></w:style>
</w:styles>'''
    
    # word/document.xml
    document = f'''<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<w:document xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main"
            xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships">
  <w:body>
    {body_xml}
    <w:sectPr>
      <w:pgSz w:w="11906" w:h="16838"/>
      <w:pgMar w:top="1440" w:right="1440" w:bottom="1440" w:left="1440"/>
    </w:sectPr>
  </w:body>
</w:document>'''
    
    # Build the ZIP (.docx)
    with zipfile.ZipFile(output_path, 'w', zipfile.ZIP_DEFLATED) as zf:
        zf.writestr('[Content_Types].xml', content_types)
        zf.writestr('_rels/.rels', rels)
        zf.writestr('word/_rels/document.xml.rels', doc_rels)
        zf.writestr('word/styles.xml', styles)
        zf.writestr('word/document.xml', document)
    
    print(f"Creado: {output_path} ({os.path.getsize(output_path)} bytes)")

# --- Main ---
files_to_convert = [
    {
        'inputs': ['INFORME_AUDITORIA.md'],
        'output': 'INFORME_AUDITORIA.docx',
        'title': 'Informe de Auditoria'
    },
    {
        'inputs': ['INVENTARIO_CLIENTES.md'],
        'output': 'INVENTARIO_CLIENTES.docx',
        'title': 'Inventario de Clientes'
    },
    {
        'inputs': ['PROTOCOLOS_OPTIMIZADOS.md', 'PROTOCOLOS_OPTIMIZADOS_P2.md', 'PROTOCOLOS_OPTIMIZADOS_P3.md'],
        'output': 'PROTOCOLOS_OPTIMIZADOS.docx',
        'title': 'Protocolos Optimizados'
    }
]

for item in files_to_convert:
    combined = ''
    for inp in item['inputs']:
        path = os.path.join(BASE_DIR, inp)
        with open(path, 'r', encoding='utf-8') as f:
            combined += f.read() + '\n\n'
    
    out_path = os.path.join(BASE_DIR, item['output'])
    create_docx(combined, out_path, item['title'])

print("\nConversion completada!")
print("Archivos generados:")
for item in files_to_convert:
    p = os.path.join(BASE_DIR, item['output'])
    if os.path.exists(p):
        size_kb = os.path.getsize(p) / 1024
        print(f"  {item['output']}: {size_kb:.1f} KB")
