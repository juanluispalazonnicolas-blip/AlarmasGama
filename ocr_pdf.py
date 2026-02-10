import fitz  # PyMuPDF
import pytesseract
from PIL import Image
import io
import sys

# Configurar Tesseract
pytesseract.pytesseract.tesseract_cmd = r'C:\Program Files\Tesseract-OCR\tesseract.exe'

pdf_path = r"c:\Users\Juanlu\Desktop\ALARMAS GAMA\PROTOCOLOS GAMA SEGURIDAD.pdf"
output_path = r"c:\Users\Juanlu\Desktop\ALARMAS GAMA\PROTOCOLOS_TEXTO.md"

doc = fitz.open(pdf_path)
total_pages = len(doc)
print(f"PDF tiene {total_pages} paginas")

all_text = []

for page_num in range(total_pages):
    page = doc[page_num]
    print(f"Procesando pagina {page_num + 1}/{total_pages}...")
    
    # Primero intentar extraer texto digital
    text = page.get_text()
    
    if text.strip():
        all_text.append(f"\n## Pagina {page_num + 1}\n\n{text.strip()}")
    else:
        # Si no hay texto digital, usar OCR
        # Renderizar la pagina como imagen a 300 DPI
        mat = fitz.Matrix(300/72, 300/72)
        pix = page.get_pixmap(matrix=mat)
        img_data = pix.tobytes("png")
        img = Image.open(io.BytesIO(img_data))
        
        # OCR con Tesseract en espanol
        ocr_text = pytesseract.image_to_string(img, lang='spa')
        
        if ocr_text.strip():
            all_text.append(f"\n## Pagina {page_num + 1} (OCR)\n\n{ocr_text.strip()}")
        else:
            all_text.append(f"\n## Pagina {page_num + 1}\n\n[Pagina sin texto extraible]")

doc.close()

# Guardar resultado
full_text = "# PROTOCOLOS GAMA SEGURIDAD\n" + "\n".join(all_text)

with open(output_path, "w", encoding="utf-8") as f:
    f.write(full_text)

print(f"\nTexto extraido guardado en: {output_path}")
print(f"Total caracteres: {len(full_text)}")
print("\n--- PREVIEW ---")
print(full_text[:3000])
