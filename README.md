# Dosya İndirme Projesi

Bu proje, kullanıcı bir URL'e gittiğinde otomatik olarak bir dosya indiren basit bir web sayfasıdır.

## Özellikler

- ✅ Sayfa açıldığında "Dosya İndiriliyor" mesajı gösterilir
- ✅ Otomatik dosya indirme başlatılır
- ✅ Modern ve şık tasarım
- ✅ Vercel ile uyumlu

## Vercel'e Yükleme

### 1. Yöntem: Vercel CLI ile

```bash
# Vercel CLI'yi kurun (henüz kurmadıysanız)
npm install -g vercel

# Proje klasörüne gidin
cd /Users/dogukansimsek/.gemini/antigravity/scratch/dosya-indirme-projesi

# Deploy edin
vercel
```

### 2. Yöntem: GitHub üzerinden

1. Bu klasörü bir GitHub repository'sine yükleyin
2. Vercel hesabınıza giriş yapın (https://vercel.com)
3. "New Project" butonuna tıklayın
4. GitHub repository'nizi seçin ve import edin
5. Deploy butonuna tıklayın

### 3. Yöntem: Vercel Dashboard ile Drag & Drop

1. https://vercel.com adresine gidin
2. "Add New..." > "Project" seçeneğine tıklayın
3. Bu klasörün tamamını sürükleyip bırakın
4. Deploy butonuna tıklayın

## Dosya Yapısı

```
dosya-indirme-projesi/
├── index.html          # Ana sayfa
├── dosya.zip          # İndirilecek dosya
├── vercel.json        # Vercel yapılandırması
└── README.md          # Bu dosya
```

## Not

İndirilen dosya: `Mayatech_Bilgisayar_Sorgu_Araci.zip`
