from selenium import webdriver
from selenium.webdriver.chrome.service import Service
from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.common.keys import Keys
from selenium.webdriver.support import expected_conditions as EC
from datetime import datetime
from bs4 import BeautifulSoup
import time
import pandas as pd 

opsi = webdriver.ChromeOptions()
opsi.add_argument('--headless')
servis = Service('chromedriver.exe')
driver = webdriver.Chrome(service=servis, options=opsi)

shopee_link = "https://shopee.co.id/Komputer-Aksesoris-cat.11044364"
driver.set_window_size(1800, 2100)
driver.get(shopee_link)
rentang = 500 
i = 1

while i <= 10:  # Gulingkan halaman sebanyak 10 kali
    akhir = rentang * i
    perintah = "window.scrollTo(0," + str(akhir) + ")"
    driver.execute_script(perintah)
    print("Loading ke-" + str(i))
    time.sleep(1)
    i += 1

time.sleep(15)
driver.save_screenshot("home1.png")
content = driver.page_source
driver.quit()

data = BeautifulSoup(content, 'html.parser')

i = 1
base_url = "https://shopee.co.id"

list_nama, list_harga, list_link, list_terjual, list_alamat = [], [], [], [], []
import sys

# Fungsi untuk mencetak teks dengan karakter yang aman untuk dienkoding
def safe_print(text):
    try:
        sys.stdout.buffer.write(text.encode(sys.stdout.encoding, errors='replace'))
        sys.stdout.buffer.write(b'\n')
    except Exception as e:
        print(f"Error saat mencetak: {str(e)}")

for area in data.find_all('div', class_="col-xs-2-4 shopee-search-item-result__item"):
    print('Data proses ke-' +str(i))
    
    # Mencari elemen <a> dengan atribut 'href'
    link_element = area.find('a', href=True)
    
    if link_element:
        link = link_element['href']
    else:
        link = "Link tidak tersedia"
    
    nama_element = area.find('div', class_="APSFjk cB928k skSW9t")
    
    try:
        # Mencoba mendapatkan teks nama
        nama = nama_element.get_text()
    except AttributeError:
        # Jika tidak ada teks, lanjutkan ke iterasi berikutnya
        continue
    
    harga = area.find('span', class_="KwA6xi").get_text()
    terjual = area.find('div', class_='QE5lnM _2pKDjP').get_text()
    
    alamat_element = area.find('div', class_='gmAE2k')
    
    try:
        # Mencoba mendapatkan teks alamat
        alamat = alamat_element.get_text()
    except AttributeError:
        alamat = ""
    
    list_nama.append(nama)
    list_harga.append(harga)
    list_link.append(link)
    list_terjual.append(terjual)
    list_alamat.append(alamat)
    
    i += 1
    print("----")

df = pd.DataFrame({'Nama': list_nama, 'Harga': list_harga, 'Link': list_link, 'Terjual': list_terjual, 'Alamat': list_alamat})
writer = pd.ExcelWriter('komputer.xlsx', engine='openpyxl')  # Perbarui engine ke openpyxl
df.to_excel(writer, 'Sheet', index=False)
writer._save()  # Gunakan _save() daripada save()
