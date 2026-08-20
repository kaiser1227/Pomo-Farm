from PIL import Image, ImageChops

def remove_black_background(img_path, out_path):
    img = Image.open(img_path).convert("RGBA")
    datas = img.getdata()
    
    new_data = []
    # threshold for black
    for item in datas:
        if item[0] < 30 and item[1] < 30 and item[2] < 30:
            new_data.append((0, 0, 0, 0))
        else:
            new_data.append(item)
            
    img.putdata(new_data)
    
    bbox = img.getbbox()
    if bbox:
        img = img.crop(bbox)
        
    try:
        resample = Image.Resampling.LANCZOS
    except AttributeError:
        resample = Image.LANCZOS
        
    img = img.resize((300, 300), resample)
    img.save(out_path, "PNG")

remove_black_background(
    "/Users/akm/.gemini/antigravity-ide/brain/9536483a-e7d3-420c-bed7-b40d3814f058/realistic_tomato_body_1787035922275.png",
    "/Users/akm/focus_pact/assets/images/tomato_body.png"
)
print("Image processed successfully.")
