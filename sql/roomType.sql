CREATE TABLE RoomType (
    id INT PRIMARY KEY IDENTITY(1,1),
    name NVARCHAR(50) NOT NULL,
    price INT NOT NULL,
    capacity INT NOT NULL,
    description NVARCHAR(500) NULL,
    special_features NVARCHAR(500) NULL,
    image_url NVARCHAR(255) NULL
);

INSERT INTO RoomType (name, price, capacity, description, special_features, image_url)
VALUES
(N'��H��', 35000, 1, N'���G�ξA', N'���x, �q��', N'images/room7.png'),
(N'���H��', 20000, 2, N'�G�H�@��A���²�����p�]�p�A�A�X����P��y', N'�N��B�ӤH���d�B�B�c�B�q���B���I�s�a', N'images/room2.png'),
(N'�|�H��', 17000, 4, N'�Ŷ��e���A�A�X����P����ͬ�', N'�N��B�@�Φ��d�B�B�c�B�@�ιq���B���I�s�a', N'images/room3.png'),
(N'���H��', 15000, 6, N'�h�H�@��A�`�����@�K�Q�P���ʡA�g�ٹ�f', N'�N��B�@�ΪŶ��B�@�Φ��d�B�B�c�B�@�ιq���B���I�s�a', N'images/room4.png'),
(N'�L��ê��H��', 25000, 1, N'����ʤ��K�̳]�p�A�L���e�B�e���B�L��ê�ïD�A���ɥͬ��K�Q�P�w��', N'�L��ê�ïD�B�L���e�]�p�B���I�s�a�B�N��B�B�c�B�q���B�ߤ�', N'images/room5.png'),
(N'�ҩd�С����H�M��', 28000, 2, N'�A�X��Q�@��A��Ƥ������ɾQ�P�W�߽ïD�A���U�p�K�P�ξA', N'�W�߽ïD�B�����d�B�N��B�B�c�B�q���B���I�s�a', N'images/room6.png'),
(N'�����g�M�ϩЫ�', 20000, 1, N'�]���w�����@�P���Ҿɤ޼ХܡA���C�g�����I�A�A�X�����ץ�������', N'�N��B�q���B²�Ʈa��B�ɤ޼ХܡB�w�����B���I�s�a', N'images/room6.png'),
(N'���i�С]�������^', 30000, 1, N'�t�������]�ƻP���@�䴩�A�A�X�ݪ������@�γN�����i�����', N'�����ɡB�N��B�W�߽ïD�B���I�s�a�B�������y�B�B�c�B�q��', N'images/room6.png'),
(N'���س�H��', 32000, 1, N'���ѿW�ߴ��[���x�P�ɯŮa��A�A�X�l�D�ͬ��~�誺����', N'�N��B�[�j�ɡB���d�B�B�c�B�q���B���I�s�a�B���[���x�B���ŮѮ�', N'images/room6.png'),
(N'�L���H��', 38000, 1, N'���Ѷ������A�ȻP�Ф����@�H���I�s�t�ΡA�ɦ������p�P�K�Q��', N'�N��B�B�c�B�q���B�W�߽ïD�B���I�s�a�B24�p�ɷ��@�����B�F�o��', N'images/room6.png'),
(N'�������H��', 36000, 2, N'�e���ξA�����H�Ŷ��A�����W�߽ïD�P���}���]�p', N'�N��B���H�ɡB�����d�B�B�c�B�q���B�W�߽ïD�B���I�s�a�B�\Ū�O', N'images/room6.png'),
(N'�L�����H��', 42000, 2, N'�������M�г]�p�A���a���U�ϻP²���p�СA���ɩ~��ۥѫ�', N'�N��B���H�ɡB�W�߫��U�B²���p�СB�B�c�B�q���B���I�s�a', N'images/room6.png'),
(N'���ť|�H��', 26000, 4, N'�C�ɳ]�m�jî�P�ӤH�d�A���U���p�P����', N'�N��B�jî�ɦ�B�ӤH�d�B�@�ΦB�c�B�@�ιq���B���I�s�a', N'images/room6.png'),
(N'�L��|�H��', 30000, 4, N'�ɯŷ��@�Ŷ��A�C�����ɦ��b�j���P�W�߾\Ū�O', N'�N��B�b�j���]�p�B�\Ū�O�B�ӤH���d�B�B�c�B�@�ιq���B���I�s�a', N'images/room6.png'),
(N'���Ť��H��', 22000, 6, N'�Ŷ��W���}�n�A���Ѧh�����ǳ]�p�P�����y���', N'�N��B�j���@�Φ��d�B����y��B�B�c�B�q���B���I�s�a', N'images/room6.png'),
(N'�L�碌�H��', 26000, 6, N'���a���ʪŶ��P���@�䴩�A�ȡA���Ѹg�ٻP�ξA���U�����', N'�N��B�@�Υ𮧰ϡB���@�����B�@�Φ��d�B�B�c�B�@�ιq���B���I�s�a', N'images/room6.png'),
(N'�s�H��', 2000, 1, N'�A�X�������ξA��H��', N'�N��, �q��, �L��ê�]�I', N'images/room6.png'),
(N'�s�H��', 2000, 1, N'�A�X�������ξA��H��', N'�N��, �q��, �L��ê�]�I', N'images/room6.png');