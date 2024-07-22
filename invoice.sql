CREATE DATABASE tokopedia_invoice;

USE tokopedia_invoice;

-- Tabel pembeli
CREATE TABLE pembeli (
    id_pembeli INT AUTO_INCREMENT PRIMARY KEY,
    nama_pembeli VARCHAR(60) NOT NULL,
    alamat VARCHAR(100),
    provinsi VARCHAR(50),
    kota VARCHAR(50),
    kecamatan VARCHAR(50),
    kabupaten VARCHAR(30),
    kode_pos VARCHAR(10),
    no_telepon VARCHAR(20)
);

	-- Tabel penjual
CREATE TABLE penjual (
    id_penjual INT AUTO_INCREMENT PRIMARY KEY,
    nama_penjual VARCHAR(60),
    alamat_penjual VARCHAR(100),
    prov VARCHAR(50),
    kota VARCHAR(50),
    kecamatan VARCHAR(50),
    kabupaten VARCHAR(30),
    no_telepon VARCHAR(20),
    nama_toko VARCHAR(20)
);

-- Tabel barang
CREATE TABLE barang (
    id_barang INT AUTO_INCREMENT PRIMARY KEY,
    nama_barang VARCHAR(50) NOT NULL,
    kondisi VARCHAR(50),
    jumlah_barang INT,
    keterangan VARCHAR(200),
    harga INT,
    diskon INT
);

-- Tabel metode_pembayaran
CREATE TABLE metode_pembayaran (
    id_metode_pembayaran INT AUTO_INCREMENT PRIMARY KEY,
    jenis_pembayaran VARCHAR(40),
    no_rek INT,
    metode_pembayaran VARCHAR(50)
);

-- Tabel jasa_pengiriman
CREATE TABLE jasa_pengiriman (
    id_jasa_pengiriman INT AUTO_INCREMENT PRIMARY KEY,
    nama_jasa_pengiriman VARCHAR(50),
    lama_pengiriman INT,
    no_resi VARCHAR(50),
    alamat_kirim VARCHAR(100),
    tarif_ongkir INT
);

-- Tabel transaksi
CREATE TABLE transaksi (
    id_transaksi INT AUTO_INCREMENT PRIMARY KEY,
    id_pembeli INT,
    id_barang INT,
    id_penjual INT,
    id_jasa_pengiriman INT,
    biaya_kirim INT,
    jenis_pembayaran VARCHAR(50),
    harga INT,
    total_harga INT,
    FOREIGN KEY (id_pembeli) REFERENCES pembeli(id_pembeli),
    FOREIGN KEY (id_barang) REFERENCES barang(id_barang),
    FOREIGN KEY (id_penjual) REFERENCES penjual(id_penjual),
    FOREIGN KEY (id_jasa_pengiriman) REFERENCES jasa_pengiriman(id_jasa_pengiriman)
);

-- SELECT JOIN 
SELECT 
    t.id_transaksi,
    p.nama_pembeli,
    b.nama_barang,
    pj.nama_penjual,
    j.nama_jasa_pengiriman,
    t.biaya_kirim,
    t.jenis_pembayaran,
    t.harga,
    t.total_harga
FROM transaksi t
JOIN pembeli p ON t.id_pembeli = p.id_pembeli
JOIN barang b ON t.id_barang = b.id_barang
JOIN penjual pj ON t.id_penjual = pj.id_penjual
JOIN jasa_pengiriman j ON t.id_jasa_pengiriman = j.id_jasa_pengiriman;

SELECT 
    b.nama_barang,
    b.harga,
    pj.nama_penjual,
    pj.nama_toko
FROM barang b
JOIN penjual pj ON b.id_barang = pj.id_penjual;

SELECT 
    p.nama_pembeli,
    mp.jenis_pembayaran,
    mp.no_rek,
    mp.metode_pembayaran
FROM transaksi t
JOIN pembeli p ON t.id_pembeli = p.id_pembeli
JOIN metode_pembayaran mp ON t.jenis_pembayaran = mp.jenis_pembayaran;

-- Stored Procedures
DELIMITER $$

CREATE PROCEDURE add_pembeli (
    IN p_nama_pembeli VARCHAR(60),
    IN p_alamat VARCHAR(100),
    IN p_provinsi VARCHAR(50),
    IN p_kota VARCHAR(50),
    IN p_kecamatan VARCHAR(50),
    IN p_kabupaten VARCHAR(30),
    IN p_kode_pos VARCHAR(10),
    IN p_no_telepon VARCHAR(20)
)
BEGIN
    INSERT INTO pembeli (nama_pembeli, alamat, provinsi, kota, kecamatan, kabupaten, kode_pos, no_telepon)
    VALUES (p_nama_pembeli, p_alamat, p_provinsi, p_kota, p_kecamatan, p_kabupaten, p_kode_pos, p_no_telepon);
END$$

DELIMITER ;

DELIMITER $$

CREATE PROCEDURE add_barang (
    IN b_nama_barang VARCHAR(50),
    IN b_kondisi VARCHAR(50),
    IN b_jumlah_barang INT,
    IN b_keterangan VARCHAR(200),
    IN b_harga INT,
    IN b_diskon INT
)
BEGIN
    INSERT INTO barang (nama_barang, kondisi, jumlah_barang, keterangan, harga, diskon)
    VALUES (b_nama_barang, b_kondisi, b_jumlah_barang, b_keterangan, b_harga, b_diskon);
END$$

DELIMITER ;

DELIMITER $$

CREATE PROCEDURE get_transaksi_by_pembeli (
    IN p_id_pembeli INT
)
BEGIN
    SELECT 
        t.id_transaksi,
        p.nama_pembeli,
        b.nama_barang,
        pj.nama_penjual,
        j.nama_jasa_pengiriman,
        t.biaya_kirim,
        t.jenis_pembayaran,
        t.harga,
        t.total_harga
    FROM transaksi t
    JOIN pembeli p ON t.id_pembeli = p.id_pembeli
    JOIN barang b ON t.id_barang = b.id_barang
    JOIN penjual pj ON t.id_penjual = pj.id_penjual
    JOIN jasa_pengiriman j ON t.id_jasa_pengiriman = j.id_jasa_pengiriman
    WHERE t.id_pembeli = p_id_pembeli;
END$$

DELIMITER ;

-- Masukin Data
INSERT INTO pembeli (nama_pembeli, alamat, provinsi, kota, kecamatan, kabupaten, kode_pos, no_telepon)
VALUES
('MARKA', 'RL 30 NO 1', 'Banten', 'Tangerang', 'Kelapa Dua', 'Bonang', '15810', '08132456723'),
('John Doe', 'Jl. Sudirman No. 1', 'DKI Jakarta', 'Jakarta Selatan', 'Kebayoran Baru', 'DKI Jakarta', '12345', '08123456789'),
('Andi Pratama', 'Jl. Merdeka No. 10', 'Jawa Barat', 'Bandung', 'Coblong', 'Bandung', '40132', '08123456789'),
('Siti Nurhaliza', 'Jl. Sudirman No. 20', 'Jawa Timur', 'Surabaya', 'Gubeng', 'Surabaya', '60281', '08234567890'),
('Budi Santoso', 'Jl. Diponegoro No. 5', 'DKI Jakarta', 'Jakarta Pusat', 'Menteng', 'Jakarta Pusat', '10310', '08345678901'),
('Ani Susanti', 'Jl. Pemuda No. 15', 'Jawa Tengah', 'Semarang', 'Semarang Tengah', 'Semarang', '50132', '08456789012'),
('Dedi Hermawan', 'Jl. Kartini No. 25', 'Sumatera Utara', 'Medan', 'Medan Barat', 'Medan', '20111', '08567890123'),
('Rina Mulyani', 'Jl. Ahmad Yani No. 30', 'Bali', 'Denpasar', 'Denpasar Selatan', 'Denpasar', '80231', '08678901234'),
('Eko Purnomo', 'Jl. Imam Bonjol No. 8', 'Yogyakarta', 'Yogyakarta', 'Jetis', 'Yogyakarta', '55233', '08789012345'),
('Sri Wahyuni', 'Jl. Pahlawan No. 50', 'Kalimantan Selatan', 'Banjarmasin', 'Banjarmasin Tengah', 'Banjarmasin', '70111', '08890123456');

INSERT INTO penjual (nama_penjual, alamat_penjual, prov, kota, kecamatan, kabupaten, no_telepon, nama_toko)
VALUES
('Ridwan Wijaya', 'Jl. Tebet Raya No. 4', 'DKI Jakarta', 'Jakarta Selatan', 'Tebet', 'DKI Jakarta', '08133445566', 'GadgetStore'),
('Fitri Yulia', 'Jl. Mangga Dua No. 3', 'DKI Jakarta', 'Jakarta Utara', 'Pademangan', 'DKI Jakarta', '08122334455', 'ElectronicShop'),
('Agus Santoso', 'Jl. Mawar No. 7', 'DKI Jakarta', 'Jakarta Timur', 'Duren Sawit', 'Jakarta Timur', '08345678901', 'Toko Agus'),
('Lestari Indah', 'Jl. Anggrek No. 9', 'Jawa Tengah', 'Semarang', 'Banyumanik', 'Semarang
', '08456789012', 'Toko Lestari'),
('Budi Hartono', 'Jl. Seruni No. 11', 'Sumatera Utara', 'Medan', 'Medan Timur', 'Medan', '08567890123', 'Toko Budi'),
('Wulan Sari', 'Jl. Kamboja No. 13', 'Bali', 'Denpasar', 'Denpasar Barat', 'Denpasar', '08678901234', 'Toko Wulan'),
('Eko Saputra', 'Jl. Flamboyan No. 15', 'Yogyakarta', 'Yogyakarta', 'Gondokusuman', 'Yogyakarta', '08789012345', 'Toko Eko'),
('Siti Aminah', 'Jl. Dahlia No. 17', 'Kalimantan Selatan', 'Banjarmasin', 'Banjarmasin Utara', 'Banjarmasin', '08890123456', 'Toko Siti'),
('Ahmad Hidayat', 'Jl. Teratai No. 19', 'Riau', 'Pekanbaru', 'Marpoyan Damai', 'Pekanbaru', '08901234567', 'Toko Ahmad'),
('Dewi Lestari', 'Jl. Bougenville No. 21', 'Sulawesi Selatan', 'Makassar', 'Panakkukang', 'Makassar', '08112345678', 'Toko Dewi');

INSERT INTO barang (nama_barang, kondisi, jumlah_barang, keterangan, harga, diskon)
VALUES
('Laptop', 'Baru', 10, 'Laptop terbaru dengan spesifikasi tinggi', 15000000, 10),
('Smartphone', 'Baru', 20, 'Smartphone terbaru dengan kamera terbaik', 5000000, 5),
('TV LG 43 Inch', 'Baru', 10, 'TV LG 43 Inch Full HD dengan teknologi smart TV', 5000000, 20),
('Kamera Canon EOS', 'Baru', 8, 'Kamera DSLR Canon EOS dengan lensa 18-55mm', 6000000, 10),
('Smartwatch Apple', 'Baru', 30, 'Smartwatch Apple dengan fitur kesehatan dan olahraga', 7000000, 5),
('Blender Philips', 'Baru', 20, 'Blender Philips dengan daya 600W dan 3 kecepatan', 500000, 10),
('Mesin Cuci Samsung', 'Baru', 12, 'Mesin cuci Samsung dengan kapasitas 7kg dan fitur quick wash', 3000000, 15),
('Sepeda Lipat', 'Baru', 18, 'Sepeda lipat dengan rangka aluminium dan 7 kecepatan', 2500000, 10),
('Kulkas Sharp 2 Pintu', 'Baru', 5, 'Kulkas Sharp 2 pintu dengan kapasitas 180 liter', 4000000, 20),
('Bantal', 'Baru', 2, 'Bantal empuk kualitas bintang 5', 300000, 5);

INSERT INTO metode_pembayaran (jenis_pembayaran, no_rek, metode_pembayaran)
VALUES
('Transfer Bank', 123456, 'BCA'),
('Transfer Bank', 987654, 'Mandiri'),
('Transfer Bank', 123478, 'BCA'),
('Transfer Bank', 098765, 'Mandiri'),
('Transfer Bank', 111222, 'BRI'),
('Transfer Bank', 555666, 'BNI'),
('Transfer Bank', 999888, 'CIMB Niaga'),
('Transfer Bank', 444555, 'Permata Bank'),
('Transfer Bank', 222333, 'Bank Danamon'),
('Transfer Bank', 888777, 'Bank Mega');

INSERT INTO jasa_pengiriman (nama_jasa_pengiriman, lama_pengiriman, no_resi, alamat_kirim, tarif_ongkir)
VALUES
('JNE', 3, 'JNE123456', 'RL 30 NO 1', 20000),
('Tiki', 2, 'TIKI987654', 'Jl. Sudirman No. 1', 15000),
('Pos Indonesia', 4, 'POS123987', 'Jl. Merdeka No. 10', 10000),
('SiCepat', 1, 'SICEPAT654321', 'Jl. Sudirman No. 20', 12000),
('J&T Express', 2, 'JNT654987', 'Jl. Diponegoro No. 5', 18000),
('Ninja Xpress', 3, 'NINJA789654', 'Jl. Pemuda No. 15', 16000),
('Wahana', 5, 'WAHANA321654', 'Jl. Kartini No. 25', 14000),
('Lion Parcel', 3, 'LION123789', 'Jl. Ahmad Yani No. 30', 17000),
('Anteraja', 2, 'ANTERA654123', 'Jl. Imam Bonjol No. 8', 13000),
('GoSend', 1, 'GOSEND987321', 'Jl. Pahlawan No. 50', 25000);

INSERT INTO transaksi (id_pembeli, id_barang, id_penjual, id_jasa_pengiriman, biaya_kirim, jenis_pembayaran, harga, total_harga)
VALUES
(1, 1, 1, 1, 20000, 'Transfer Bank', 15000000, 15020000),
(2, 2, 2, 2, 15000, 'Transfer Bank', 5000000, 5015000),
(3, 3, 3, 3, 10000, 'Transfer Bank', 5000000, 5010000),
(4, 4, 4, 4, 12000, 'Transfer Bank', 6000000, 6012000),
(5, 5, 5, 5, 18000, 'Transfer Bank', 7000000, 7018000),
(6, 6, 6, 6, 16000, 'Transfer Bank', 500000, 516000),
(7, 7, 7, 7, 14000, 'Transfer Bank', 3000000, 3014000),
(8, 8, 8, 8, 17000, 'Transfer Bank', 2500000, 2517000),
(9, 9, 9, 9, 13000, 'Transfer Bank', 4000000, 4013000),
(10, 10, 10, 10, 25000, 'Transfer Bank', 300000, 325000);

-- Cek data dari inser data
-- SELECT * FROM pembeli;
-- SELECT * FROM penjual;
-- SELECT * FROM barang;
-- SELECT * FROM metode_pembayaran;
-- SELECT * FROM jasa_pengiriman;
-- SELECT * FROM transaksi;

SHOW PROCEDURE STATUS WHERE Db = 'tokopedia_invoice';

-- CALL add_pembeli('Asep', 'Jl. Merpati 10', 'Jawa Barat', 'Bandung', 'Coblong', 'Bandung', '30124', '081234567890');
-- CALL add_barang('Bola Basket', 'Bekas', 2 , 'Bola Basket Bekas Nih', 50000, 30);

-- SELECT * FROM pembeli;
 -- SELECT * FROM barang;
