PGDMP     &                    y            auth    11.8    12.2 A    0           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                      false            1           0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                      false            2           0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                      false            3           1262    16409    auth    DATABASE     v   CREATE DATABASE auth WITH TEMPLATE = template0 ENCODING = 'UTF8' LC_COLLATE = 'en_US.UTF-8' LC_CTYPE = 'en_US.UTF-8';
    DROP DATABASE auth;
                postgres    false            4           0    0    DATABASE auth    ACL     )   GRANT ALL ON DATABASE auth TO devvirujh;
                   postgres    false    3891                        2615    2200    public    SCHEMA        CREATE SCHEMA public;
    DROP SCHEMA public;
                postgres    false            5           0    0    SCHEMA public    COMMENT     6   COMMENT ON SCHEMA public IS 'standard public schema';
                   postgres    false    3            6           0    0    SCHEMA public    ACL     �   REVOKE ALL ON SCHEMA public FROM rdsadmin;
REVOKE ALL ON SCHEMA public FROM PUBLIC;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO PUBLIC;
                   postgres    false    3            �            1259    16664    account    TABLE     ]  CREATE TABLE public.account (
    account_id integer NOT NULL,
    no_of_users bigint NOT NULL,
    sub_start_date date NOT NULL,
    sub_end_date date NOT NULL,
    account_key character varying(200) NOT NULL,
    account_name character varying(100),
    updated_time timestamp without time zone,
    updated_user integer,
    is_active boolean
);
    DROP TABLE public.account;
       public            postgres    false    3            �            1259    16725    account_account_id_seq    SEQUENCE     �   CREATE SEQUENCE public.account_account_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 -   DROP SEQUENCE public.account_account_id_seq;
       public          postgres    false    196    3            7           0    0    account_account_id_seq    SEQUENCE OWNED BY     Q   ALTER SEQUENCE public.account_account_id_seq OWNED BY public.account.account_id;
          public          postgres    false    199            �            1259    26707    patient    TABLE     �   CREATE TABLE public.patient (
    patient_id integer NOT NULL,
    phone character varying(100) NOT NULL,
    password character varying(200),
    salt character varying(100),
    "createdBy" character varying(100),
    passcode character varying(100)
);
    DROP TABLE public.patient;
       public            postgres    false    3            �            1259    34966    patient_login_patient_id_seq    SEQUENCE     �   CREATE SEQUENCE public.patient_login_patient_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 3   DROP SEQUENCE public.patient_login_patient_id_seq;
       public          postgres    false    209    3            8           0    0    patient_login_patient_id_seq    SEQUENCE OWNED BY     W   ALTER SEQUENCE public.patient_login_patient_id_seq OWNED BY public.patient.patient_id;
          public          postgres    false    210            �            1259    26705    patient_patient_id_seq    SEQUENCE     �   CREATE SEQUENCE public.patient_patient_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 -   DROP SEQUENCE public.patient_patient_id_seq;
       public          postgres    false    209    3            9           0    0    patient_patient_id_seq    SEQUENCE OWNED BY     Q   ALTER SEQUENCE public.patient_patient_id_seq OWNED BY public.patient.patient_id;
          public          postgres    false    208            �            1259    24608    permissions    TABLE     |   CREATE TABLE public.permissions (
    id integer NOT NULL,
    name character varying,
    description character varying
);
    DROP TABLE public.permissions;
       public            postgres    false    3            �            1259    24606    permissions_id_seq    SEQUENCE     �   CREATE SEQUENCE public.permissions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 )   DROP SEQUENCE public.permissions_id_seq;
       public          postgres    false    203    3            :           0    0    permissions_id_seq    SEQUENCE OWNED BY     I   ALTER SEQUENCE public.permissions_id_seq OWNED BY public.permissions.id;
          public          postgres    false    202            �            1259    16731    player_id_seq    SEQUENCE     v   CREATE SEQUENCE public.player_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 $   DROP SEQUENCE public.player_id_seq;
       public          postgres    false    3            �            1259    24619    role_permissions    TABLE     t   CREATE TABLE public.role_permissions (
    id integer NOT NULL,
    "roleId" integer,
    "permissionId" integer
);
 $   DROP TABLE public.role_permissions;
       public            postgres    false    3            �            1259    24617    role_permissions_id_seq    SEQUENCE     �   CREATE SEQUENCE public.role_permissions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 .   DROP SEQUENCE public.role_permissions_id_seq;
       public          postgres    false    3    205            ;           0    0    role_permissions_id_seq    SEQUENCE OWNED BY     S   ALTER SEQUENCE public.role_permissions_id_seq OWNED BY public.role_permissions.id;
          public          postgres    false    204            �            1259    16684    roles    TABLE     h   CREATE TABLE public.roles (
    roles_id integer NOT NULL,
    roles character varying(100) NOT NULL
);
    DROP TABLE public.roles;
       public            postgres    false    3            �            1259    16733    roles_roles_id_seq    SEQUENCE     �   CREATE SEQUENCE public.roles_roles_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 )   DROP SEQUENCE public.roles_roles_id_seq;
       public          postgres    false    3    197            <           0    0    roles_roles_id_seq    SEQUENCE OWNED BY     I   ALTER SEQUENCE public.roles_roles_id_seq OWNED BY public.roles.roles_id;
          public          postgres    false    201            �            1259    24737 	   user_role    TABLE     l   CREATE TABLE public.user_role (
    id integer NOT NULL,
    user_id bigint NOT NULL,
    role_id bigint
);
    DROP TABLE public.user_role;
       public            postgres    false    3            �            1259    24735    user_role_id_seq    SEQUENCE     �   CREATE SEQUENCE public.user_role_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 '   DROP SEQUENCE public.user_role_id_seq;
       public          postgres    false    207    3            =           0    0    user_role_id_seq    SEQUENCE OWNED BY     E   ALTER SEQUENCE public.user_role_id_seq OWNED BY public.user_role.id;
          public          postgres    false    206            �            1259    16689    users    TABLE     �  CREATE TABLE public.users (
    id bigint NOT NULL,
    name character varying(250) NOT NULL,
    email character varying(250) NOT NULL,
    password character varying(250) NOT NULL,
    salt character varying(250),
    account_id bigint,
    doctor_key character varying(200),
    is_active boolean,
    updated_time time without time zone,
    passcode character varying(100),
    "cityState" character varying
);
    DROP TABLE public.users;
       public            postgres    false    3            �           2604    34974    account account_id    DEFAULT     x   ALTER TABLE ONLY public.account ALTER COLUMN account_id SET DEFAULT nextval('public.account_account_id_seq'::regclass);
 A   ALTER TABLE public.account ALTER COLUMN account_id DROP DEFAULT;
       public          postgres    false    199    196            �           2604    34975    patient patient_id    DEFAULT     ~   ALTER TABLE ONLY public.patient ALTER COLUMN patient_id SET DEFAULT nextval('public.patient_login_patient_id_seq'::regclass);
 A   ALTER TABLE public.patient ALTER COLUMN patient_id DROP DEFAULT;
       public          postgres    false    210    209            �           2604    34976    permissions id    DEFAULT     p   ALTER TABLE ONLY public.permissions ALTER COLUMN id SET DEFAULT nextval('public.permissions_id_seq'::regclass);
 =   ALTER TABLE public.permissions ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    202    203    203            �           2604    34977    role_permissions id    DEFAULT     z   ALTER TABLE ONLY public.role_permissions ALTER COLUMN id SET DEFAULT nextval('public.role_permissions_id_seq'::regclass);
 B   ALTER TABLE public.role_permissions ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    204    205    205            �           2604    34978    roles roles_id    DEFAULT     p   ALTER TABLE ONLY public.roles ALTER COLUMN roles_id SET DEFAULT nextval('public.roles_roles_id_seq'::regclass);
 =   ALTER TABLE public.roles ALTER COLUMN roles_id DROP DEFAULT;
       public          postgres    false    201    197            �           2604    34979    user_role id    DEFAULT     l   ALTER TABLE ONLY public.user_role ALTER COLUMN id SET DEFAULT nextval('public.user_role_id_seq'::regclass);
 ;   ALTER TABLE public.user_role ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    206    207    207                      0    16664    account 
   TABLE DATA           �   COPY public.account (account_id, no_of_users, sub_start_date, sub_end_date, account_key, account_name, updated_time, updated_user, is_active) FROM stdin;
    public          postgres    false    196            ,          0    26707    patient 
   TABLE DATA           [   COPY public.patient (patient_id, phone, password, salt, "createdBy", passcode) FROM stdin;
    public          postgres    false    209            &          0    24608    permissions 
   TABLE DATA           <   COPY public.permissions (id, name, description) FROM stdin;
    public          postgres    false    203            (          0    24619    role_permissions 
   TABLE DATA           H   COPY public.role_permissions (id, "roleId", "permissionId") FROM stdin;
    public          postgres    false    205                       0    16684    roles 
   TABLE DATA           0   COPY public.roles (roles_id, roles) FROM stdin;
    public          postgres    false    197            *          0    24737 	   user_role 
   TABLE DATA           9   COPY public.user_role (id, user_id, role_id) FROM stdin;
    public          postgres    false    207            !          0    16689    users 
   TABLE DATA           �   COPY public.users (id, name, email, password, salt, account_id, doctor_key, is_active, updated_time, passcode, "cityState") FROM stdin;
    public          postgres    false    198            >           0    0    account_account_id_seq    SEQUENCE SET     D   SELECT pg_catalog.setval('public.account_account_id_seq', 1, true);
          public          postgres    false    199            ?           0    0    patient_login_patient_id_seq    SEQUENCE SET     L   SELECT pg_catalog.setval('public.patient_login_patient_id_seq', 489, true);
          public          postgres    false    210            @           0    0    patient_patient_id_seq    SEQUENCE SET     F   SELECT pg_catalog.setval('public.patient_patient_id_seq', 469, true);
          public          postgres    false    208            A           0    0    permissions_id_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('public.permissions_id_seq', 11, true);
          public          postgres    false    202            B           0    0    player_id_seq    SEQUENCE SET     <   SELECT pg_catalog.setval('public.player_id_seq', 28, true);
          public          postgres    false    200            C           0    0    role_permissions_id_seq    SEQUENCE SET     E   SELECT pg_catalog.setval('public.role_permissions_id_seq', 9, true);
          public          postgres    false    204            D           0    0    roles_roles_id_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('public.roles_roles_id_seq', 1, false);
          public          postgres    false    201            E           0    0    user_role_id_seq    SEQUENCE SET     ?   SELECT pg_catalog.setval('public.user_role_id_seq', 59, true);
          public          postgres    false    206            �           2606    16701    account account_id 
   CONSTRAINT     X   ALTER TABLE ONLY public.account
    ADD CONSTRAINT account_id PRIMARY KEY (account_id);
 <   ALTER TABLE ONLY public.account DROP CONSTRAINT account_id;
       public            postgres    false    196            �           2606    26715    patient patient_id 
   CONSTRAINT     X   ALTER TABLE ONLY public.patient
    ADD CONSTRAINT patient_id PRIMARY KEY (patient_id);
 <   ALTER TABLE ONLY public.patient DROP CONSTRAINT patient_id;
       public            postgres    false    209            �           2606    24616    permissions permissions_pkey 
   CONSTRAINT     Z   ALTER TABLE ONLY public.permissions
    ADD CONSTRAINT permissions_pkey PRIMARY KEY (id);
 F   ALTER TABLE ONLY public.permissions DROP CONSTRAINT permissions_pkey;
       public            postgres    false    203            �           2606    24624 &   role_permissions role_permissions_pkey 
   CONSTRAINT     d   ALTER TABLE ONLY public.role_permissions
    ADD CONSTRAINT role_permissions_pkey PRIMARY KEY (id);
 P   ALTER TABLE ONLY public.role_permissions DROP CONSTRAINT role_permissions_pkey;
       public            postgres    false    205            �           2606    16707    roles roles_id 
   CONSTRAINT     R   ALTER TABLE ONLY public.roles
    ADD CONSTRAINT roles_id PRIMARY KEY (roles_id);
 8   ALTER TABLE ONLY public.roles DROP CONSTRAINT roles_id;
       public            postgres    false    197            �           2606    24742    user_role user_role_pkey 
   CONSTRAINT     V   ALTER TABLE ONLY public.user_role
    ADD CONSTRAINT user_role_pkey PRIMARY KEY (id);
 B   ALTER TABLE ONLY public.user_role DROP CONSTRAINT user_role_pkey;
       public            postgres    false    207            �           2606    16709    users users_email_key 
   CONSTRAINT     Q   ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key UNIQUE (email);
 ?   ALTER TABLE ONLY public.users DROP CONSTRAINT users_email_key;
       public            postgres    false    198            �           2606    16711    users users_pkey 
   CONSTRAINT     N   ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);
 :   ALTER TABLE ONLY public.users DROP CONSTRAINT users_pkey;
       public            postgres    false    198            �           1259    24754    fki_permissionId    INDEX     Y   CREATE INDEX "fki_permissionId" ON public.role_permissions USING btree ("permissionId");
 &   DROP INDEX public."fki_permissionId";
       public            postgres    false    205            �           1259    24748 
   fki_roleId    INDEX     M   CREATE INDEX "fki_roleId" ON public.role_permissions USING btree ("roleId");
     DROP INDEX public."fki_roleId";
       public            postgres    false    205            �           1259    16713    fki_user_to_account    INDEX     K   CREATE INDEX fki_user_to_account ON public.users USING btree (account_id);
 '   DROP INDEX public.fki_user_to_account;
       public            postgres    false    198            �           2606    24749    role_permissions permissionId    FK CONSTRAINT     �   ALTER TABLE ONLY public.role_permissions
    ADD CONSTRAINT "permissionId" FOREIGN KEY ("permissionId") REFERENCES public.permissions(id) NOT VALID;
 I   ALTER TABLE ONLY public.role_permissions DROP CONSTRAINT "permissionId";
       public          postgres    false    3738    205    203            �           2606    24743    role_permissions roleId    FK CONSTRAINT     �   ALTER TABLE ONLY public.role_permissions
    ADD CONSTRAINT "roleId" FOREIGN KEY ("roleId") REFERENCES public.roles(roles_id) NOT VALID;
 C   ALTER TABLE ONLY public.role_permissions DROP CONSTRAINT "roleId";
       public          postgres    false    197    205    3731            �           2606    16719    users user_to_account    FK CONSTRAINT     �   ALTER TABLE ONLY public.users
    ADD CONSTRAINT user_to_account FOREIGN KEY (account_id) REFERENCES public.account(account_id) NOT VALID;
 ?   ALTER TABLE ONLY public.users DROP CONSTRAINT user_to_account;
       public          postgres    false    3729    196    198               �   x�}�A
�0������%&�^,V��Bd���H�z��j��l���P�RdBfB���4]s�Wg����h���1������`�5hq^��e��JVԧ2�1��"i�o�N�yC6��h��%�x��VIYA띍�=y�72��Nc<0�^��^f      ,      x�ĽG��^�:~�s��HC�HPD�u׺���������Eu5=��5Ԁ]�����?�������t�6�zi[���u�V��;W T��R�u�\�5|�u
?�ec��������[��B�i����l��*ywp��7ew� �ҫ�-�%���m
^?����� /�p�vY�h�����=I�9�<\ȶ�]x`W��-��8�~r��p��+��U?Ǧt8�xN\z� w�)"h�Aa��~/���yCh��2�Ʌ�ާv�a�������B3_iҹ�pō���A�p�+O�H&�	T.mj,��\�/\��C9s�n�iNR�3yU�ί~U�"^*�m�=Ҋ?x������'���3;ۋ�R�6�:����Hl�k훂	W�D
׽}��
�/��[?��_��;�;dXmw7xװ{�"a��>"3� ��'�m'Ǣ�Cw��~rA���|���I�6S��lv�1Ii�WJ�~2��[;ls��-�^���K����"���)N���vk��@W�����

݁����^ӳn6����2�E��z@�����3D$�IeHW����dhNǏ U{�@����~���:1�}m['����u?`���H��kʽ�<��wʗ����d,�_d�)��,29�"Tr�j�6�}�wM)�T�+(��T�a{1S��A�"k�Y?�0��D?D�w8���xX��Pu��\����!0�U9W�~?�塛�X,�_d�/d�^�w�:���(e�26��W��&<:�1��Y�+�LsúX���_���zfMW�#g/᫵�wwU3{_�(\V �r�kQg[����R,�_d�/d���ӫ��G|"�^��!�S�7RU���������l�+����[?;���?D�٭Ċg6"���i�IK�'���A� �Gܮ��6	��2�E��Bf�z��!�# voVRr�H-qD�@71�nT�J�X��Mg��J�~��fA�S��<)����fx\(�P�o���� P���l�}�^��~��fA���r��@��)��x� A�s�����A�C�{iM�~�3�L��/��,H�ԍ�rv�@�y�D-�W��#�8�)r�ђ��v����2�E��1���:�g��3�7�p�P�{���R�[$O�Ո\��f�
	~� {O�j� E�;9v0`8��ji��д�9�<��m$��	9(�2�E��am񰃘fP��1RcqG�v<*��<�LF���u`�A�L%X��~� Mt,�qy@�jPV�p�
�8�d��Z�NI�҂�"���2�E��9v�<Hm��H7v������0�]ޚ������� �D��j��I�~��fAتN��ܟ���q�h��������y3�-qŭ�}f����~��fA� �vh��T�e��2!�L��k�u��u�I�y��^@\� �y�"�͂�J,�f��v�n���_��n{u�mw����u���#����~��fALlP7��h�P���g\�S�o��y@���M�M�ه�q+u��~��fAC�6A�����꺫��tZV��`:9��f�އ��e���FX���Z��n�s~��6[�B�¦�� $�h���zI�.&�j��y�8�|Y�Uc�
��_� ��{S0sk���
�m����h��U�0k5f�k���v<w�2�E�B�T�J�.P�8ȅ��}2ظ� dJw��[9B6��	�puq���`�"�!K7�zr��N;�D�^v�v��ɼ�q�Q;X� |������n�2�E��FFk��ۘ=ʭ��Co+58u�n�]묲�qР(1O0ϣ�I�r�e����̲\��{ׅ]O���B�|���g�pWv�%	�[0\�6�m)b{M^�Ȱ_�jo[�.��<���z=*�ա=�Bs^	\GY���zu;��/2�2O�aSlF�}����E V���ڰ_s�!�&[q/�޾��e���7��9/*��ǽ_1���@=�,H"�X�@XСO�Ǝ�ɍ�~��fA�1���9]5&�TU-j���H=(]9"5�5��>n[��5DX��~�A��zn;��njB\�ª�&��̋x�TLAv��r�du���N�����[����PU�#���\sx��@��Rp�>egouf<��G�ri���˂��+���$&�~=��xJ�+p恄54��fc=T��H�kd�
���~��-��z��t�ZJ���(ۉ5g�ծ
��a�B`��+�6lh�/ꁻ�X,�_d�bz������HߵG��2��Ƴ��f�u3�h��k���m���V.�^���?O�ٕ ��x7n=φ�dR��w�KY���W�z��yƇԅpo�S"�f��Z��!H�!����������)��I�!1
�� ���e�R�Z����t��>����'����>H�.�P�ֺ�~]��1�ɉ��ze*!��TTQ� ���j@� ���U�R�����r=��ˠl�e�����c������"�)�& �&�y�}�'��O�5^[�8@,�����«��M��_�-�IN��a��Z|�
)7��&�]���vW�7�P�6a�{k��[-z�m�"��|Q!�Nl�
i=��ۜ&��l���7!�KܷU�`:X���ߐ�qly�"�!�����ult������Wd���c����9���c��1�s�:F}���A �9��=���
�z�3��F��> ��K�� �>�|�����_���ϕA�s{��/��!��}�(�֜����ԏ`u��.|��:�������Ø��d�^�.� 12õ�2��ND^=�H��wP/\�ׂ�A<ݮm쨣<��������{�UX����X��ö���B�a�F���-:&�_�D�]�D��j88�k���m6^�E���H�	ۍ����j,�����rI��� 0�Q|����׃��EΪ^�6`^�ȸ�f����g-���6������Tr,�������2���&��:�J�\}r�I;�<G�&m��o�������d���N���i<'�^���mKn�>��V���0d[]�J+��IL��;޵+�k�����[�=��9)�F����rz���a�G98Z�
�&�Z�9�pbk���� {����,v��sR�}��y?�`�&���竝��|p�
�o���c�7q�n� w�������_���=�P��[0�w�J�,��M��G�.�����['T��m纆�OL�;xF
�#)h�1ޤ�]ʴVx�1t-?N�D�/�-|p��7��Ɗ=S\�:����6��sR��R�F�9�M��B��;�?��֕1�ْ?E�z}��ѯ���8��S�=WSC�;��|�ʸ0��EܺZ����r8��{�)m2vǮ�����~+�oe��K`�r'C�&o��%���f}"�{HZIU��r�����e��[��6����XG��T��"�=�J�L�Q!�G.�"2a0{��!�;3f���~K��w�	~;�u��y�����r� ��	Lq���'���Ż-���X�I��M�8b��}Nvl_nu����.�W�M�=ƞ-��Zj�*�K�fӺ�`����?$>�H���e���э�9~��<��N��,�ۧ�m���1e�����{ �q@9�Ҷ�=���-"�Ҟ˴�p�5�>���流�.r�$pp�/S�f��A���Y����Q[��uFwc���5�r�A`�8sX׼W"FnТt����ۅL{�aP���̓�O���?� ԏ>���C��������R���:���Qr{0�B��7���&��I���w���A����g�g,���N<��N����r�L�Y"P�GL��
N~��"t�5�x}~4&:�vjT���C��5�ᨢ?��g�:���l?DO��`c?�������;��!"&F�����F�?����'5��؁� ���\
�����-��9���x�Dq&��Gс7�lwyY%uvv/�UE���N�Z3o�����i���Q�ȷu�l�Ң@b�d�H�    �q0�A@*	�S�\iB\mXi<Z܊VR�U1��e�t�ME"(D��$�v�.8 tW���c�\4cݺ�u�(t��0�v����2xN�~H������_����+�J��P�9gt}��76?7p�{")I��;���b�w?��x��4*�w�1Q�'R�#�A��d>� J����f|g�כ�i<'�?��(������z�`TE�$p+�]'wǹ��ul�RR�vF��5����9)�!}+�y߳6*����M�w��~�eֵg�*x�9ր믍5���9)�!};O/I��e�[�-�h���g�naTnm.��R�1B9�0�'��<'�>��}"Sy/�鄻�>@L`s���e�쯽��}UD�uF�d�X�i<#�GS9����ۍ1s$at45��TN�(I�1%�	�i��H۱�*'�p$֏<�D밿�,uK�- i�$k)��v�2|<?U����h�`�Gl��-"ȷ\įZ��*kS o�)7p�Zw,�$W�U�Ŷ��#�U�ـ7�d<?����Q�F��M��c�26��yGZ�>��*G?�%�����k���҃�aͅBID(���3LQv���1���Úw�=v�2v�+�C!|�r��ǩU8�<��8�vn�όK�w����>c�W\�ב���a�Ɓ���1&� ����?�N�Ș� ��?�}U������?~�f���n��G��C��U\�x�g��s�h԰�i��\��a
9��o��F��T���mP��Hа��3�dŞ�%U��pW�=��v��V�ql��u~d�|�/�g-?��
e�����MM>F�c&���.�gauѧ��=��)N����E�Q��\���Я���Da_�rF��%�7��K�o�QG� O�v��+������������4N� ��>�gݸm�:�`CT����[0��w��}��~ 
_�����ln]L[w�J�0	Eh3�eLH[͊΂e�wRtTP��N5��Xx<�Ac�9�(�(��@%	c����20ݱ@�su]�Q�ɎsnF{�m����x�$�#gc<k�1��<0
$?����XWVǯ	�XVĦj��@������j GP"r3�mhz�2xN:i%�(�=�Ɵ�,��Om���JJL$j�������D`��^����a�����`�P�'e*�j����e�p߄�sڛ�!8A{��g�([��u��(�dT��.2m<��1�'P�����dy���|���q�^��C�*Sڣ����7���B���KJ5Xϲ{|�iȘ;��~��Ap?���d�G�� G�d�G�h�F��� ��D����U�u֦�y{,ut��#�	n��"�@���[U�;r'��#ii�sIO[ϯn̊j
�(�}!���;�Ҳ���z �M+�<>�閡�4���Lv��g��sR�������j���+� �&R;zC܍vݡ�%��A�d�6�
��<�Tm���V,��c�@����6[��H��)�u���:=����[��s����+��|��Pam�)�����j�B�;��v�f��ž���6x_�6c:�)��g*��ei�R>��isq�[S���
��8���y�j4����}�h=Rh��:4	��+��N�?(�Ƽ��'��X��q�ߞ��sR�E:y�w\��X1��Y�>b�V:W�b�A������@*R9��)j��5�X�I'39�N�wz����=:/!�t�41�,%W�,hu��
�82�5��K����"c��?;�fn���DlNv;���bU;Z��uEg�;'������ܔ��,�礣ݘ*�س���?9BY�{o`[���p&;�;��j��VQ���+�}��<'�޹�'��e�J3���`�C9"1#/�o@��v9���@��`�VX�gЖ�sR|
�@�>��JH��3/�Ca��Ud�m��n�kqBL#� ��UsFo�~&������Fb 	�;�W�|�-c\��G
��q�5߬�mОJ��z��\��v��s�1��0bL�I�煨���'�����sQ(H ���fu�i@jth:�8�K�!&!N�%c��"rLa��d����I�%������~d<�4Ҁ"8B�I�CD==5i*2��W�_ԏ�$�Y�E�/"����w�����h��(�w��_��SҺ �� ��!�#
����|�7zn4���z�����}��dQ[��&2%�(b��`����E�*�;��j덅J�����!�K8׃ֶ���ӏ~�I��"N����%��\Ng��r��.�A{2��:V��1�)�����A ����ORb�R�m12E �-��ui�������x@i��nےB���hS����2xN:zvp�Xpd���5x�l0��������%����dB?yU���90DƟwx�0��e���y�ʩ��̃�1~����ކN���l��������G�*��4IE����T���I����y��i���?�Ǵf��k�ɭv����]+�ĚrT�+6����I�F��Օ��# 9����Fm+6U�����Q�޿���b+5�B�ih� c��^8����e���~4%+	£���b��w���ܛ����6bp��Q7�kV�v�#{AnE���k2WU�d<'����׻0���qP�'��6[�X+�@��!���W�#��q��?�:a<'����_��琐�&X�J8Xf�B�w��d�c�ۭ6�ٔ�@=�֯m(����2xN�<�Y�<v�f*6z��5<����q�K/��<�L�����@�`/8q��s���l"4�7	�%d��`<?����H����)����A�0��&Ks�Q����\?������+h�K�`�{-4����sR�NP(������������"�J���Ð2v�9�E��`�����}*�J�+��m>cͿ���ؼ�C ��r=U��g�}�{����1>S��:�J[]a��Xw����涅�����t>��t�^4����VZ��x �3���?�x*�׌�o��䏢ب<?=�h1�1*�ʃ�<��G�z��Ǜ<7wS������L�?{��� "� ��������y�aZ�2M��ۏ2����QLe���i$����69�M��c@h�1>�. `��y�С���~��ѣ�==��Kx<�+S%���=N��
�L���J0..���,@���1s�I+��
���vw��p��Wm<'E?������ใ%c>�8^��F�nݶa��z�H�&�:ܖ�{3/L�[x<'Eޤ��J1R��NX���j{��ۀp�t�n���&J���<-h��{_�I�g�#GC��r����ެ��C���5R	b^/�y�pU�Q�`҈��w�1!ŗ�s�)O�*�ķ�(�ż̦HZ'�6����������-��Z��3r �J���x�w�B���*�*���U{
#��^���뇏{>t�
]�
{4�L֪�q͚`�stp�C̥�^�=(t�2x��4|B��_8���������{�
�4F���!+�ZA� B�"Nݖ��j}`�e�z&_�/~�|Ynz�oA@�)�.58	�� �'l��%����0M0��sp+/�g��T'�f���k���l �
c.b�MZ+�Qb.6�a�S�����ir��,��гy�����@���2*\�w2J�?*���Z��ns0e|�՚�{���2xN�LG�I}�R��Y�������yP���Ѣk���Q��1�~�X�rw�2xN:����?�1��{=�P# z��n��j_�AQ�4��
�R&�>,�"߽u>�����塋��][�O�3&ܣ���[�G���3�&��M�H�^+��6&�R~�ɰbج��+X����v�@��Iț�8��l*�ƣ���0��v.�`7�eɆ�!�_�l�b�P�e����FF�7�ä�y'�m�	��v��ƶp1�!��Jg����ʣC�n}��w�t*i����o��2@��(�����0���',�/��}|�    ����'AqkU�{�;xN:��1����A���S��$��"A�5QQ:%�ܩ�s�!����^�;������eb"dg�G�(/�g�CA���k��W�{��x��EOL�cʶa�����.��� k˂k̤H��Y_|<'�6�55d��l�W��'��U+(�Lo�yH5�<f���d
���L�Gd9-d!п��D��,C�.��������Ư�����2`=���/�CP?~�5�=�9E�%���%S�x�@pt��f��.�-7}����� ����9�u4�?&�" ��ފ��_��%�gJ,5��W�$�s��o�Y��M�$�\B|$�\�*�пK�8�s�>%<k�s(�ӎN.�VavG��\�&���\t�����"`��pm<�=<�"
��t���(�$�4�9o���OΓF�Y���Q����T�D)���=�LS%�$~��3�j��"�ߨ�?��L&}Z�86>�mi���@׳]o]/oOй ���w�U�:��Fi�іk��G�����H�-IL�D���� ���{;���'��k(�l��3� 蒅��	M��T��������Nsr|J�?��ʕ�?��gڱ
8�� i�[���[[�<R����z�P�2xF����֤������y��#v] Hs��
'����C+�Wn�o����N�1��&_�ua�Z-���e͋���_Eb{��9��L�gjܒR�������9)�i�F�p�+.�{ޖ�ˮy���Ɗ]���!6���!���:�w�yN��o��_��n�@���2�X�^�¬ȋ&��Tb�ڏ�ߔ��zZ�I�_Hi8��h��%��M�8�g1��P��^,�<��$E<��2xN�r[���9kA��,�j�<Z�itg."�������8�c2����h����T�"�?��a�J��bt� ��K!��6w��S��9<}W�	����R�Tw]c�s��5&��B���D��(<�>O��@-;� �p�ߗI�0	8��L����w��=&�~�&rm���y����Ò����)v	���<��hl؅�KL�;�	��sR�R)nc�	��[km��Aj��E}X�����P�2ؙ���V ������>�S��@�8�����6ѥ����`��cI*$��V!�0]�C����,��Sw�|���_ܹ5�G�ʐvR��Y�i�e_��:GJ�:���L�n�*���'��<#����7���0H�*��I��đ/�Dc��ǐT�l��������gY���9鳣a�k8j֛0�?����yG�o˲E�\u�� �Z<V��	z<����m�}��C�#؆��K���*�)�AP�{��1���c,���2�7���+�|�Uz��(T��s��TNm M˵�fWl�l+hH�kc������4w��Fn����Nv�:)�0n���e����=$��\�"�딪2ə-�aQ�'���@؛m�1V�j�4_�I�/��s� 2-��+"���M��O�$��G~���bh�yM�q��G܃�ѝ����-í�$M�W��F�FҨ`1����SV���X�.�?�s}��٧�d�3g�V5����	x;2�x��f�b�5�D��̦=��n</�^��k�O���h<[�n��j �5y1
��P�*�Vv�e/�c+�p��Xp�@����5d���2x�D�4�����.�(Q�"�zi��)�m�_n�=�[�W�i��{1�����9)���
4_�1��8��:K>�q�Jk6��~sC�9�|@��9o��a�8 �/��������3Ť�M�7[HT���{;���1�C�ѫqN蹕����P�vR���e��o���۲*#X�� �*��gbUv������%tm5)3;<j]�V�z���-���/�� �4�\�>>�>d80�-� $�X�+�q��/P�P���V'`<'}��i6�٭AhR���y�U�	_g����ݐb�LDG�O���W+�eJᇧe��tZy�l�\C����\�yYL${� �1��h!�u��g���A�d�i�H]�ن�w��9W�@�eҟ��`am!�7�`��~�:o��쇭��+p�m�d�`-�.�r��x����N\�����Ie7��UpX�%���,��a�Yr�C~J�G��H��lS���Y�ǽ����?�Kf��w��*��7���vg����2H�
���*:�tLH-�F_~ϯ��z`�3v�S�P�W����NO�n�1�)iY�W���k�
�!�0S�9-�礯U�S��Lwկ��W�{Y[B)<(�FwڰK�1���Cɬ|뤯(�^E�2xN:U���Ƒ��SI�U$�`���]1#R�� ��#�$�gtVc�+gKm_����,��ӂ�i�Y��<����ۺ�*�Q�І� b�p/�Qt����&��Igj�am<'��sl?�AQ�b'��;`R�%���F���t��&�n�#�5�WA�=:����<#����K�����CT�{���^C�@�tM�Z��LN�1�d`�������*���B��n�*:S�٬�˱�&e gK������9a�;�|]�ʵP��y�e�y�ǰo;���}��q��5G�N���;�{v�;�'�Fܡx}����>���s����6��El�N��ak���)�ߵ�*'D�'l{3�*�C�TH��ɔ��s�i��('�����l�W�9����� �J*`7��N��G�D4��Zz�e�
��s�W�����R�"&t�í���!�b Ӑ!Ǖk��L�M��9���΂#�j�e����� ���B[c��=*ڦ����r�갵xUv��^c�̯��Χ�@����sR���0L!���h �K�}*dVA���� F��D=�Ҋ�Z_�������l`��sR���GM�f6UDX��k(����tߐ8��VH��� l�5{�b����r��n�0���R��Y����l)�D���*���x�����$V=����{�Ry<'��+�;���������^{	��3���׮���2��`��P禱��)@_@��O�I�ȁ�8�-0���o���68R���UD��֡��i�U2l�ց��l�����+x<'E~!]ݎ$��+�e���i�][8���@+6���M,�k������2xN����s>ؗ��k�T���>��{\cLPh1ȗbS�Q��_�����u�҇Ϻ���sR���N�L�S�-�Ρ:.��t�Z�푮����A��;�V:�r�z�X����2xN��B���(�)@��{�N >��Ÿ��Ŭ�^_�=���&�����O/3&R�g΂گ|�S�W��CO�s��w\	�VuQ�L���+Z^���m����qb#����ٴ��w9��[��V�Æ ]�Q�C�(��ç�@�w��o�3���>��$�i��[�V�#[[��Y�W���*�
�Vʫ-K ��EW�u�:�<䚫m����i�g��i.��Q@>�l �����fP�^L�#Y����戏�k��k��[`<'}��_��0EzH��v:�X^��:SK��!�9�X��灨��}����sR�����D�n݈�]�8_�VX���^�_oZ�^��Xd���X�z�U��e��,d}{�?���&Ws7^�Y��tY���:x nW��u��	�o�Q
)�yV���9)�!����Yb��@�o}9E4��g
%�2*|�ަ�A��}7<����b�w�%�����/K\A�ю�n�x�BY���^��FB�S�X�I�?�}�ޑ�d��Z������`K���lO	���r�B�m=�$�_�I�ϕ~���ٸ�8��U��F�`ޭ���6� ;�~�~|	"�~``�O9[[�I����
��C��uv�%�TubUS����fx����2�=Txg]z+��sR�S	[�1�+ϧR��'c���-���U�ެ������=�T��G=6�����'    �����jW�P��j���yL����	U�]�R��x�@>�P�*7&V�fe��2xN��H�.##;O;{j�߆GqH�:���gF�Wc4kzvn�ee�7��ɒe��C�(���O6 �h���$f��~bEt-h�A��ݔ:��18g�8�^qM> ��sR�I
>�|�<B�oIt�6���_�*$��/%yiC�]q$n���9�]$?k���@�xp�
K���@��,�A{MN���Z{�%�g:���v@���:mL�.�N~;v�ސ�p�\9�� ܟ��&;��'���R�+\�	bl,��W�Me�Q��o{@��2#.�١B�=OwTeU �\���a��\(�zr�vwa<'�?��ݼ�۵���z�I4��n����O�U�K�uI޺N�E��lT�P����NEfB��ߊ$]���5�;��ecܙ�^�v<�(���#\������8�»�+c<� ����}�G3#Ǔ"?k��˾�><9(#r|����5t;��7��l��m���
IM����/�OM�w�%�{
�c�f�>�j�������`Oo�C��0�1�	Y/i�Ԡ�)���o��
�i7��������O=N� �?"C>d�?N�~���rB؇�������2�'#?d�?NF}Ȩ�l�����ɠ7�ϓ},�ϓ},�ϓ},�ϓ},�ϓ�-�? {[�@�� ����mA��y[�@�eA��ٗ!�d_��_�}Y�A�ׂ��������� ��������8�!��i2����>
}���X�?d�x��"�<�G��?�؇�����~���!{MH�������B�4��3�s}M��9���"��`����YB?�����]�}�<XE���K���?�Z!v,_+�-�%�M�`Ѿ����%n�2xN
�����w���7T~�.g��W�	��$��k��Pj*hA����0ʶ��/�9)��3�m��x�nkVܙ����:�KK[o�ux�\�o�*�M;������sR�M��r:�*�q�8���`�-m�� ^�!�G�}r&N���P����f<'�^�}o��ޚ�)�����8ɀ��
Aa�Ҷ�>v�
qA�:���y-d,���s��9)B���k9�е��E��!ߒ�"�#E��^Ze��G@UO�a<'%�<K����ua�Wx^���D��V��2K���ފF���Usib�q$Y�I�}�_���wtc���k��.�@ܮ���KB��޺M���.m�Z>�[v<'}.W�v��V����y���%D&<��a�ٕS9�*m�.P�J>���Ū�.�v�gI���)~H��8o����֎9����d�í���bP��wA�<�B�k�ʁ���0���sR�m>�,�ÅI}AO������u��$u�p;eG�D�y�A�r� �|�����V���>��lG����멄ϥ:��/rp̮���eEY�����n�@�[����P�{S����Qa�>+�Ġ��3M�F�����6�A��Rr�ˉ3ʠ#����]��C�W_m�h/	F��H������~��$2��PdC���f�URc�ju�����~S�\��zp��x�� <;�a�� p㝖���%��v���0�~+�N=��"''���o� ��F��<@>@����"��lu����w����A�%q{�7�[���#!%��cS�����SA���;�c�X#�?�Nt��-�x�2x�q$��8d�q$�b���x|ރѲ}&��|���g��fB�~��,"�l�h��!ՙ�D�HoME�������ﳂA|T�i	Ibc�BC&�:5��?%aK��+sE���G�rw)Ǧ��	���/�!u�a8��7-��x����Kٿ��(���:��v��"�N=oIq��w8��ꖮѽqm���i���p�8�[�[�*���$�p��弳�]lhӳa@a����ۧ��������ŗ�Z!G���'��S%lEãS�`|�`�NqARȂ��1�^E-��{Yc6����/�?�������[�>˽V�V ��kK�<�\�#�|�t�K�BtCv����XF�h��[�iIǐz�TA��VT�i.xK�$w�àP��9�7��!ڸ��HdE��,�ߴE��LR#��rNme��@�rw�[�W �����_A{����j�3��^I0��oZ����V>}�ϫﵺ�)�utN���u�;�C�,�T��"+�auM��q||X�MP���|�B��6�Β\�a��;r]|U{#{����_���q��r�r���?���ފ�vE�i��/$���^�QO=5Dt�p��U9�T`]:�F�`���|�X��⿦ѱ�:� ����C_���ُ�w.���T�ͪY� �+���	Wd��+c?��4Dv��a�QF�5�=i���B��b�J]s,[@>�N�����ֺ{�����~���5����E���k�w���C�d��U(Ș
����s`#<ͩ����Qx=�k�8��rr��$Bzz)�
ۍ��,�?fAF���g�l��bO+9���z <����Q�G_5���9v�!r%&�?7S�Hxz���s���z��r���a���+�#����q�Q�F	�mŰG��Yw*�h��.ؘ����sk��3����nY�!I��Ms���h6�U�V���/�/g{����w�G{0d���5�Yk��f(�g���owe�Ua׫����â�X�v{�����p@"��W��!��Y2&Y�B���ҥ�����6�g�R��JN����'d��15�GA���3�hy�1Q2�%lڸ�z� ���rn����l���KQ�r���\������؋���H�8E8qy�Pg�Qjr�	��Q��6�(�M|j��UƇe�;Fn��p=�B(��ߨ��b�QKu$���_Cӽ>!D(��Lu"ȓ"��Uf��6Z���t�&u�w���QwC�1���9'�RC���1�>k��͂)��\enw-5<pkYN��+Bq��*/��7���"5�T%Q�=��42�JM�T����������3"5�*��_j��j)�|qp��-N�V`ǻ]Q,�?��x�1cçG�"�g{�|?x>!���gӭ)��;n]�;�2��U����T� ��e�7�LM����(l��اp%W�L��� Rb�f�+`�S+v;��2D�-x�����^I�e��ގ��H;�9��ßF�L���������?��a�<:,n���]K�	gsݯ:��2�C�c������Mo��;Q���|C�ʫF����-~T�d�K�zW؞���JD�������c�;��x��xe@gb���;�!���ڪY/����]������x�W�_aW׵���1L�a.#%z%�s�(җ$�����Rk��k��������g�Lhg���D���&���^��N66��RD�-)�;�,w�%b�w(�{�D͌1�#��ëxZ����,@8�u���n��rP�=9K�ʦ�dM!%$ˠηg0Be�s(ԳM��h������ Z��W�r(%��V�/�PeU:�W
�UA��1�]Ҟ/�8�˅�{��s ����Ih�8��
_����M:��!�E���E��Q.���I���ÚC��LOl���Uc����n�)�i�2K�3��)��q���'r���T)�&P��E4�E�$l ��~�S �E����2QO�^�FXא|�j�� ]�f�����N*W�j�r+:i���Z#�s$31�9'�#V���&Z��x���Um��,��V1�z����,�ӓ��DIf|�.!2�q��lЌC���]�-n�JČ��"�\<��;h&'Ǉݎ�1~��o)�ն�/W�~�9�e�lǿ��q�	#AB��_A�D��E�c%�H�
�b�3wP���L
�����8 �3����R",�� �o�62r�q'ѯu�%jj�}�Kֶ����ޓ�4j>�=�xt7��;�;�5�ZkI��n 9   �����&_Z��D\��#��9323OS\T����e��ґc ���)�5��� �      &   �   x�}��
� ���Ô���n�Ш�+���o�ij��|�����~R�;cyD�S@u�S�J�����$z�~/������!����*�K�S^���J$T�ږAʍ�etC�	�݈a��!]��Y�s�lo��Ǳ6��:7���j��y��'�Z�Z�E�k o���`      (   Q   x����0�j1L^�Y�%�ϑS(F�a�9Y�b�I����B��f��:HV!��hZ��B;f�iy:V�j���7��z�I          4   x�3�tt����2�t�w��21���=�C�B�L8C<]��=... �
�      *   �  x�-��m1�3'CM�sq�q����j�4�"O䗑ףGo#�<ft�����cG'���ї�Z��Tt:���cP҈AJ3-�ĴcPӉAN7�l1�bԹ2��1��I/gLz�b�З;�`���yc.Os�f*�afL��h��>���3V2W,�g��|F-�g��|F-�g��|F-�gԮ��9�Q����������������u�u�S�8�:�:�:�:�:�:�:����mW\zF]zF]�ϨKϨKϨKϨK�(5�V�Q4K��]j�`|�ej��45����5N��uj�͓(�'Q6P�l�D�D��ˢl�D�J���e;%ʆ*)[��l����J��*)[����r���t�c7X�6�U�Y�<�U�Z�B�U[[�H�U�\o�,��B�?�Jٮ�T�뭕�z�e��jٯ�\� ����-��@�b܁jɸ�����Z4�A�j܃j�~������      !      x�ŜY��ںﯝ�����N��M]-A�@Q��z�O�*�Zs%'�v��*����O� 
����q�F�EwT9v0)����{#� +�L�����]c�QP��U%Q+�@�> X-�H0j�d��I�p�mAY�nٌ�'ЄM���!���~}��N�2v��x��n&�}	��%okR=;J�}q�5.�m)n�����n����0���֡�*�뵿���;����i �؆k���e����$4��B�1b��~�#�w��E^��w�*�=�j!2�ĩJK6Q�r�+����6�%%a(�@�S�.�q��A�D�t�9Nf\��F�Y0�?��m\�(J�y�թ�4�|��l�֊�&gi|ܪ����ݱ�I1��w|�p�@I�>qp���oJ7�wӻ�$���}~k�8��zq�k{I���up
fU�ݶ)��`�6�;�&LQ�K��ev�NT���
b�C:wH��N~����Mh`	l�0&���� �@�	( }6�����'ݨ|Z���߈��l:�Uq������w��W ���v���m�y������������A��0G������%���Ȝ�Q�o��h��$�۵_�?y�w@à/M��O�7���k��u�pbܯ�oy�(~V�~�-���w#�:�)C����}���f���Z�>~��
���H�#wt �@g��ﶅ|�ҙ@R��<�C����ݵ�"�I3��W&�Ѳ�r�E*�a�w";��0�]p����$>.��x60�'0/F�̴t��VP��v50mY�"�]@5�v�� ��n[��u6��5���zF#G��l�w�l1�g�LBr6[��*�pD4���n�1D�i�u��Y�}��9?.���)=��L`{�����;C�9�y�V:��
 pM��JY�1Q	�/]� j���)?.��Y��@��'��*��z������6��YB9����@Ea|R��= ��ジ�������V$Jk c^�D�R�n�`�Y���HDL.�T��ȅ�R�*댋{��A��6�A�@yӜT[�p�_O{�.)�rG&$P��cՅoN�N��+��V𸸧|^&]��~��y���M�w�.7�_�![��p��GB�c�;
0�!8��+ڮ"�5�h���Rs�X�ę��0s�p�+�Q3�O���s���?}^��˹�D˿���՗�]먴�K>[�VY��X���h�ZS�ը+�T�t.+|\ܳ=�e�HIܑu+��J�ΣV
8ݴ��^Ui�%%�k����m�h<�������e��|\��</�.Ш~��]�Y���]Y��Y ,x�H^b��h8�	s��Um(�T������Y��]���y����wf~���I�u�Kf?����ߕ� �$��|"�n)v��v������m�}��7Y��:}Gq $P${Vb����8٤���o�A�'��� ���t�D������02&]��%�����C>{�|�;J
w��&J�."���s7��$�fg�J	P��;0L�}�����D2�l]���d����b����?�*.�K�� � �|�B�UW5FF�8QL��q~?�UB�3�A�(0A�=`W�=����ҹ?�U:�~Ga���{<t�t#v�
ȉ�88�j:@|���qCq�o���b�M���=ua7�:�|��*��׹n�1���l߸\�M03�.������WI?�6F��8�`�{RbBgƣo?��h\����+�C�}�r�^�$�0��2��$'�v9V���N�h8�е�U�RǑ��+#嬺��fW%*��׍^+��z9#��/�*>.�[�� ��[�EvO��<�������qS�����5M��3>�$�ki8�-S`Z+�8�7��b-��4�ӹ.^���6�Lխ�գ������O7 �F�ߞqy&ܯ��+2~ys�j�"����BZR���qD7��w��f�X���z����Q?#����5���n���'!���M�f��eDy�W�T���x�
I�`�D��3�Q������� ��XF2�C�Ot�����*�G3�M�˨[ol�ԥҏ�;��l��L[�wP��ν�Ñ����RM�1?�W�ݑԤ�,1�I�2� �/2c�,tQ�1��c|����-�����~���1_�kS]�I�䄹
p�nEXd��Bth�_�x�Zh�ܒb�qqOF>W��#ҾuQ͈�G��<��~����`]�P�W@��B���%J��骐����.�3���ٔ�{��P(L��N�YN���U]X�N���W)?ۻ ��@ ��0ч�.�(I}i�Gy׹���$\�>Ϋ_E?A�w� C��0�O����ou����_~��d��C�P�+oŉ���@X�X��#�i8� �:j̩�p��S��M|>�ɡ�5�>��|J��="����>� j��;L7�"�u̓ڪ#�󤱚��o!��Rf~	�i�	�[+)i��sk6.����wqp�7�Ss� �遥�n(� 2!Y@?�]�?���y���h	
@��* S��w��=�sRC�Y���/�]UŞY&��1�A�*BqWL[.9�4��I��b�י�h}\�>�����c{Zϕq�an}� T��Ib���b'c��[����2V�5��� �!�������PS�w�N�u���,���,���#$�x�^�Pk� ��𪌋���� ~X��}^�+����|}������Qi#<��}d7.X
�n�$�eL{�՝/�qq���4H蹗zM����n1P�����i1�/�u�s;7^��r���Ǖ�H��\��^��v�O2�)���yA���/4��ͱ�@33>� �f�s���¤ '�]�Mcf���M<u
����aq��l�$1P��gV{�f�;�w�\�t:���B̕l�Hȴ�K*�gL�si)�D8.��g�"�'���&L���&&*U�6�,�iQ&f�h�)��ӜM��j9�!�`x�����'z�%j����.��&Nt,�8G�]Eyt�Vb���s;�w�x%0�W����m���{�gk����{����T��&�d�f
s������8v�)��a�7W�	������;����vu�Ie��{������ц=�%�u ��(�z� g�[>��.KXÇ�X9Ռ�{�g㦾n�|L���20c�3_*"���jЩ`_����F�7ʊ7�W(���Ӎ�t�ZY�_�qq��|G���#��n���S�a��#6���n��΀`.�쪢�b�o�0�o�������@�7���aw����T>*��s�ˢ$��#E\A��>���5,�G�"��AP�1.��9�Q�k������u����]��R]i�W���ٖ�OWG��s�."F3u��I�|%��K:.�=Q����	�Z�P�& �2Z[Ač�8��R�0!(�0��	S-�0g�]�����={K�[O��l�#Cn4���������2C�T-v)�*~�s�HZ�n�`���R�j\�S����	Ah�)A��/���L��@3抣Lqkҹ��2Pj#���%��1�V˔�r��~},Ґ9�⸸�zv����O,��z�&Q�gJ{U�f�^���Á���%�U��~��9��J�r\�w�^� �f�ր��EZf��p��b%f*���Il�I��,*�8e�i��mR��9����z��A��������x�����w(��]��UC��M�������L:[0nć
M/VS�����-C����(�/P�3��e���F���g�Lb��%p����K#4�~�SdVE5���N�"
�E�&ѡb	h5.��<�	�l��>d�k��N�@��70�CS�p獾�(��cy��s��}o��8��Ӯ����?�?�H�Ÿȇ��ѓ���7� �4�]�|c����%Ib��Ws�� ��m��-6m�_��ġ��͸��Wdb���v��'~u�o��}�ߡ��m��7�2;"����=hږ�,>NA��i������4"H1�G�Ľ�c/S���Fv��D�P��J�4�J�� �
  �\�Q)����":8�'��	9Z��t\܏֫�zu��c`��em�7� H�6�#jK��/���og�!a�K���c9�|)�`�7пOcu?.t��������kt]��E6���Z^b|c��4XN��Lq\�O䫋@�֠vm�σ���V���w{����P�	Bs��"
<T�7M.mk��Lvn))����j`��?�;ו��v~��;�����ZWp�$�Ɋ�U��#+3�&3-�2`��vM��F���͞���{8����qLf�5oמ�}�Zb3{5����
�>��2��P�Y��n�Ŗ�"m��=��E��5���0�r�Y��ۂy	�W������m?����Sޖp��ո�w���6����7�΍��� �n�`8�(��L�#���E��ڄ���`��F�e��V5G��<U�qq�^�8�����n�����Vx��[�^Nsف��p�ώ�4�FyK>X�y����u�f\ܳ�HL�(�����8X��k�h?Cu�!��f�[�X�53�~��VpO3jq���䰸�y�/�Y���!�mi[[r�|����Ap�������ܦ�̈́�3A�o�܌�qqo]/.�����G.�X20,="H/��A`1e�clm�Nٴ�s���ԎP��vX��{�w��P�'�dE���lW5�I�eSl �\h�¸���`'
��L��|U0�]�����zɚadj�ftN�4h�Tv꩗Eȝ�7(|�;���Ux �Eڞ��^0�l�,p5.�^<=��0}C���@����T��2?52p��uqֶ�%EՇ���HY4�y���T/q���}�����k̪w��R����W�V�͹�����NP�h���Vd�>.��^<�����A�Y�.�����B,�&2ͧ���BƐgۦ�$��9��X��nL���q���`bb�^n?>o�W�F��s����{	�]�:���_p�dSP���>IEYf�G�D�lW:�	�\9\������q��sMπ��n�W�F�v�QW#}'D곒 ��b%�g����r�y���"Z0�bq�׬����Ff��_[��g�3(�H�9��fv�����-����X�b��Ly��*X���2�g'�����Ǐ������;RzH���ͺY���� �<�A*���}f�Rp��J���iy��q�'�R!��~v��N��ӹD���@�`W���[�{V��M�w��l�)�9�V_o� ��{��,|���Q�Y���Bh��7y�[e�xN���0NE����nJ�N}��O1,�^�	��x�A�x�n�a���ӽ`nid��o��ě�\L�W!�,�n��[�2��3.��^b$2����π�/Z����u	'�W2�&�6x�횰v�L�/����<Si�\/a����Dgn���k�L��E��8f�h2�N̍�*Z"hm�����z���b�$�x��|Z����2��k�j���Qw�!�$>\�\m_��sN�+���gz���k�����B�`�9<����՝z�-��z+�a	 p{>!�Kօ����gz����Ż]��y�B�M?�-���@-�540B��~�V>\�|+����R	��>&m6����y	���3�!�glT��ivv���z��z�\���0�q+q\�A)�zf8�������y��(��3`@V2=�g���S���%�VL�AfW���d��B�2�;�����r\��_9
��@<�<�W79�F�����˝s�n�����aQ��L�9���Ę6r��_</<��o9��s��v�i�3��n�[؀�'�$X����2[m��"_6ˊ��qq��eѣ�Q�)���f� �A\Jn�85���3uUJ%���9�p(1�<�N�?Xd�ǎήE}\�5T/�-���zp�Yvh����q����Dju��5��o�� �?��S1�9a�nKg\���[Б�2�@�o�� �-�z紁�(�k�yvM�ZKI���J����&ʸ���9�ty���� �m�|���� ������c��z+0G�����P8 �&�B�Y�kԈk�%/q�j��
	*������>����0	�����1ĺ��?�������#����>�g��3��H����^k��<R��p�0s/Հ�4���$%��5����0,���E�O:wh�Al�oҝo���� X�L�+V�S�9���1�֡(���sU��tvzY\���ʼ5\3.��{��(��d�'���l_`/����]�cl�)�����M��ݶ�I��
$�4�.io�q�ٸ���%2�Ԥ
b�y{������,����b]Hc��e~�x��G�~��=�E�%W�h�� ��/��`���ب'�$�8��d� q�d�J�����8T���~��֬�o��]�m@��$���v���#��]"sq��'�mdMa���M;�[r*�n@ E1Ŭ��B��Ӷ��+\��`�f��.�r��_\/q	�y���v�k���sɍ��bu(�pXBn�Z��4�p����/��x�ؾ�.�9�A��0��c�}�(�������D�����Y3�[��:M35�ܛ&l���~������� ���ǉ��70ݻ#o��g��+��wn��R�pPq�p�s�8���U�H�zU���	�Ⱥ-�_�Q������/��������w%      A    0           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                      false            1           0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                      false            2           0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                      false            3           1262    16409    auth    DATABASE     v   CREATE DATABASE auth WITH TEMPLATE = template0 ENCODING = 'UTF8' LC_COLLATE = 'en_US.UTF-8' LC_CTYPE = 'en_US.UTF-8';
    DROP DATABASE auth;
                postgres    false            4           0    0    DATABASE auth    ACL     )   GRANT ALL ON DATABASE auth TO devvirujh;
                   postgres    false    3891                        2615    2200    public    SCHEMA        CREATE SCHEMA public;
    DROP SCHEMA public;
                postgres    false            5           0    0    SCHEMA public    COMMENT     6   COMMENT ON SCHEMA public IS 'standard public schema';
                   postgres    false    3            6           0    0    SCHEMA public    ACL     �   REVOKE ALL ON SCHEMA public FROM rdsadmin;
REVOKE ALL ON SCHEMA public FROM PUBLIC;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO PUBLIC;
                   postgres    false    3            �            1259    16664    account    TABLE     ]  CREATE TABLE public.account (
    account_id integer NOT NULL,
    no_of_users bigint NOT NULL,
    sub_start_date date NOT NULL,
    sub_end_date date NOT NULL,
    account_key character varying(200) NOT NULL,
    account_name character varying(100),
    updated_time timestamp without time zone,
    updated_user integer,
    is_active boolean
);
    DROP TABLE public.account;
       public            postgres    false    3            �            1259    16725    account_account_id_seq    SEQUENCE     �   CREATE SEQUENCE public.account_account_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 -   DROP SEQUENCE public.account_account_id_seq;
       public          postgres    false    196    3            7           0    0    account_account_id_seq    SEQUENCE OWNED BY     Q   ALTER SEQUENCE public.account_account_id_seq OWNED BY public.account.account_id;
          public          postgres    false    199            �            1259    26707    patient    TABLE     �   CREATE TABLE public.patient (
    patient_id integer NOT NULL,
    phone character varying(100) NOT NULL,
    password character varying(200),
    salt character varying(100),
    "createdBy" character varying(100),
    passcode character varying(100)
);
    DROP TABLE public.patient;
       public            postgres    false    3            �            1259    34966    patient_login_patient_id_seq    SEQUENCE     �   CREATE SEQUENCE public.patient_login_patient_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 3   DROP SEQUENCE public.patient_login_patient_id_seq;
       public          postgres    false    209    3            8           0    0    patient_login_patient_id_seq    SEQUENCE OWNED BY     W   ALTER SEQUENCE public.patient_login_patient_id_seq OWNED BY public.patient.patient_id;
          public          postgres    false    210            �            1259    26705    patient_patient_id_seq    SEQUENCE     �   CREATE SEQUENCE public.patient_patient_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 -   DROP SEQUENCE public.patient_patient_id_seq;
       public          postgres    false    209    3            9           0    0    patient_patient_id_seq    SEQUENCE OWNED BY     Q   ALTER SEQUENCE public.patient_patient_id_seq OWNED BY public.patient.patient_id;
          public          postgres    false    208            �            1259    24608    permissions    TABLE     |   CREATE TABLE public.permissions (
    id integer NOT NULL,
    name character varying,
    description character varying
);
    DROP TABLE public.permissions;
       public            postgres    false    3            �            1259    24606    permissions_id_seq    SEQUENCE     �   CREATE SEQUENCE public.permissions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 )   DROP SEQUENCE public.permissions_id_seq;
       public          postgres    false    203    3            :           0    0    permissions_id_seq    SEQUENCE OWNED BY     I   ALTER SEQUENCE public.permissions_id_seq OWNED BY public.permissions.id;
          public          postgres    false    202            �            1259    16731    player_id_seq    SEQUENCE     v   CREATE SEQUENCE public.player_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 $   DROP SEQUENCE public.player_id_seq;
       public          postgres    false    3            �            1259    24619    role_permissions    TABLE     t   CREATE TABLE public.role_permissions (
    id integer NOT NULL,
    "roleId" integer,
    "permissionId" integer
);
 $   DROP TABLE public.role_permissions;
       public            postgres    false    3            �            1259    24617    role_permissions_id_seq    SEQUENCE     �   CREATE SEQUENCE public.role_permissions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 .   DROP SEQUENCE public.role_permissions_id_seq;
       public          postgres    false    3    205            ;           0    0    role_permissions_id_seq    SEQUENCE OWNED BY     S   ALTER SEQUENCE public.role_permissions_id_seq OWNED BY public.role_permissions.id;
          public          postgres    false    204            �            1259    16684    roles    TABLE     h   CREATE TABLE public.roles (
    roles_id integer NOT NULL,
    roles character varying(100) NOT NULL
);
    DROP TABLE public.roles;
       public            postgres    false    3            �            1259    16733    roles_roles_id_seq    SEQUENCE     �   CREATE SEQUENCE public.roles_roles_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 )   DROP SEQUENCE public.roles_roles_id_seq;
       public          postgres    false    3    197            <           0    0    roles_roles_id_seq    SEQUENCE OWNED BY     I   ALTER SEQUENCE public.roles_roles_id_seq OWNED BY public.roles.roles_id;
          public          postgres    false    201            �            1259    24737 	   user_role    TABLE     l   CREATE TABLE public.user_role (
    id integer NOT NULL,
    user_id bigint NOT NULL,
    role_id bigint
);
    DROP TABLE public.user_role;
       public            postgres    false    3            �            1259    24735    user_role_id_seq    SEQUENCE     �   CREATE SEQUENCE public.user_role_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 '   DROP SEQUENCE public.user_role_id_seq;
       public          postgres    false    207    3            =           0    0    user_role_id_seq    SEQUENCE OWNED BY     E   ALTER SEQUENCE public.user_role_id_seq OWNED BY public.user_role.id;
          public          postgres    false    206            �            1259    16689    users    TABLE     �  CREATE TABLE public.users (
    id bigint NOT NULL,
    name character varying(250) NOT NULL,
    email character varying(250) NOT NULL,
    password character varying(250) NOT NULL,
    salt character varying(250),
    account_id bigint,
    doctor_key character varying(200),
    is_active boolean,
    updated_time time without time zone,
    passcode character varying(100),
    "cityState" character varying
);
    DROP TABLE public.users;
       public            postgres    false    3            �           2604    34974    account account_id    DEFAULT     x   ALTER TABLE ONLY public.account ALTER COLUMN account_id SET DEFAULT nextval('public.account_account_id_seq'::regclass);
 A   ALTER TABLE public.account ALTER COLUMN account_id DROP DEFAULT;
       public          postgres    false    199    196            �           2604    34975    patient patient_id    DEFAULT     ~   ALTER TABLE ONLY public.patient ALTER COLUMN patient_id SET DEFAULT nextval('public.patient_login_patient_id_seq'::regclass);
 A   ALTER TABLE public.patient ALTER COLUMN patient_id DROP DEFAULT;
       public          postgres    false    210    209            �           2604    34976    permissions id    DEFAULT     p   ALTER TABLE ONLY public.permissions ALTER COLUMN id SET DEFAULT nextval('public.permissions_id_seq'::regclass);
 =   ALTER TABLE public.permissions ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    202    203    203            �           2604    34977    role_permissions id    DEFAULT     z   ALTER TABLE ONLY public.role_permissions ALTER COLUMN id SET DEFAULT nextval('public.role_permissions_id_seq'::regclass);
 B   ALTER TABLE public.role_permissions ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    204    205    205            �           2604    34978    roles roles_id    DEFAULT     p   ALTER TABLE ONLY public.roles ALTER COLUMN roles_id SET DEFAULT nextval('public.roles_roles_id_seq'::regclass);
 =   ALTER TABLE public.roles ALTER COLUMN roles_id DROP DEFAULT;
       public          postgres    false    201    197            �           2604    34979    user_role id    DEFAULT     l   ALTER TABLE ONLY public.user_role ALTER COLUMN id SET DEFAULT nextval('public.user_role_id_seq'::regclass);
 ;   ALTER TABLE public.user_role ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    206    207    207                      0    16664    account 
   TABLE DATA           �   COPY public.account (account_id, no_of_users, sub_start_date, sub_end_date, account_key, account_name, updated_time, updated_user, is_active) FROM stdin;
    public          postgres    false    196            ,          0    26707    patient 
   TABLE DATA           [   COPY public.patient (patient_id, phone, password, salt, "createdBy", passcode) FROM stdin;
    public          postgres    false    209   �        &          0    24608    permissions 
   TABLE DATA           <   COPY public.permissions (id, name, description) FROM stdin;
    public          postgres    false    203   W        (          0    24619    role_permissions 
   TABLE DATA           H   COPY public.role_permissions (id, "roleId", "permissionId") FROM stdin;
    public          postgres    false    205   �                   0    16684    roles 
   TABLE DATA           0   COPY public.roles (roles_id, roles) FROM stdin;
    public          postgres    false    197   [        *          0    24737 	   user_role 
   TABLE DATA           9   COPY public.user_role (id, user_id, role_id) FROM stdin;
    public          postgres    false    207   >        !          0    16689    users 
   TABLE DATA           �   COPY public.users (id, name, email, password, salt, account_id, doctor_key, is_active, updated_time, passcode, "cityState") FROM stdin;
    public          postgres    false    198   �       >           0    0    account_account_id_seq    SEQUENCE SET     D   SELECT pg_catalog.setval('public.account_account_id_seq', 1, true);
          public          postgres    false    199            ?           0    0    patient_login_patient_id_seq    SEQUENCE SET     L   SELECT pg_catalog.setval('public.patient_login_patient_id_seq', 489, true);
          public          postgres    false    210            @           0    0    patient_patient_id_seq    SEQUENCE SET     F   SELECT pg_catalog.setval('public.patient_patient_id_seq', 469, true);
          public          postgres    false    208            A           0    0    permissions_id_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('public.permissions_id_seq', 11, true);
          public          postgres    false    202            B           0    0    player_id_seq    SEQUENCE SET     <   SELECT pg_catalog.setval('public.player_id_seq', 28, true);
          public          postgres    false    200            C           0    0    role_permissions_id_seq    SEQUENCE SET     E   SELECT pg_catalog.setval('public.role_permissions_id_seq', 9, true);
          public          postgres    false    204            D           0    0    roles_roles_id_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('public.roles_roles_id_seq', 1, false);
          public          postgres    false    201            E           0    0    user_role_id_seq    SEQUENCE SET     ?   SELECT pg_catalog.setval('public.user_role_id_seq', 59, true);
          public          postgres    false    206            �           2606    16701    account account_id 
   CONSTRAINT     X   ALTER TABLE ONLY public.account
    ADD CONSTRAINT account_id PRIMARY KEY (account_id);
 <   ALTER TABLE ONLY public.account DROP CONSTRAINT account_id;
       public            postgres    false    196            �           2606    26715    patient patient_id 
   CONSTRAINT     X   ALTER TABLE ONLY public.patient
    ADD CONSTRAINT patient_id PRIMARY KEY (patient_id);
 <   ALTER TABLE ONLY public.patient DROP CONSTRAINT patient_id;
       public            postgres    false    209            �           2606    24616    permissions permissions_pkey 
   CONSTRAINT     Z   ALTER TABLE ONLY public.permissions
    ADD CONSTRAINT permissions_pkey PRIMARY KEY (id);
 F   ALTER TABLE ONLY public.permissions DROP CONSTRAINT permissions_pkey;
       public            postgres    false    203            �           2606    24624 &   role_permissions role_permissions_pkey 
   CONSTRAINT     d   ALTER TABLE ONLY public.role_permissions
    ADD CONSTRAINT role_permissions_pkey PRIMARY KEY (id);
 P   ALTER TABLE ONLY public.role_permissions DROP CONSTRAINT role_permissions_pkey;
       public            postgres    false    205            �           2606    16707    roles roles_id 
   CONSTRAINT     R   ALTER TABLE ONLY public.roles
    ADD CONSTRAINT roles_id PRIMARY KEY (roles_id);
 8   ALTER TABLE ONLY public.roles DROP CONSTRAINT roles_id;
       public            postgres    false    197            �           2606    24742    user_role user_role_pkey 
   CONSTRAINT     V   ALTER TABLE ONLY public.user_role
    ADD CONSTRAINT user_role_pkey PRIMARY KEY (id);
 B   ALTER TABLE ONLY public.user_role DROP CONSTRAINT user_role_pkey;
       public            postgres    false    207            �           2606    16709    users users_email_key 
   CONSTRAINT     Q   ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key UNIQUE (email);
 ?   ALTER TABLE ONLY public.users DROP CONSTRAINT users_email_key;
       public            postgres    false    198            �           2606    16711    users users_pkey 
   CONSTRAINT     N   ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);
 :   ALTER TABLE ONLY public.users DROP CONSTRAINT users_pkey;
       public            postgres    false    198            �           1259    24754    fki_permissionId    INDEX     Y   CREATE INDEX "fki_permissionId" ON public.role_permissions USING btree ("permissionId");
 &   DROP INDEX public."fki_permissionId";
       public            postgres    false    205            �           1259    24748 
   fki_roleId    INDEX     M   CREATE INDEX "fki_roleId" ON public.role_permissions USING btree ("roleId");
     DROP INDEX public."fki_roleId";
       public            postgres    false    205            �           1259    16713    fki_user_to_account    INDEX     K   CREATE INDEX fki_user_to_account ON public.users USING btree (account_id);
 '   DROP INDEX public.fki_user_to_account;
       public            postgres    false    198            �           2606    24749    role_permissions permissionId    FK CONSTRAINT     �   ALTER TABLE ONLY public.role_permissions
    ADD CONSTRAINT "permissionId" FOREIGN KEY ("permissionId") REFERENCES public.permissions(id) NOT VALID;
 I   ALTER TABLE ONLY public.role_permissions DROP CONSTRAINT "permissionId";
       public          postgres    false    3738    205    203            �           2606    24743    role_permissions roleId    FK CONSTRAINT     �   ALTER TABLE ONLY public.role_permissions
    ADD CONSTRAINT "roleId" FOREIGN KEY ("roleId") REFERENCES public.roles(roles_id) NOT VALID;
 C   ALTER TABLE ONLY public.role_permissions DROP CONSTRAINT "roleId";
       public          postgres    false    197    205    3731            �           2606    16719    users user_to_account    FK CONSTRAINT     �   ALTER TABLE ONLY public.users
    ADD CONSTRAINT user_to_account FOREIGN KEY (account_id) REFERENCES public.account(account_id) NOT VALID;
 ?   ALTER TABLE ONLY public.users DROP CONSTRAINT user_to_account;
       public          postgres    false    3729    196    198           