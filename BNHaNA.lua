-- Made by Artheriax
-- Github: https://github.com/Artheriax/BNHaNA
-- Took inspiration from Gigantix: https://github.com/DavldMA/Gigantix/tree/main

local Banana = {}

-- Notation table for suffixes used in short notation

local NOTATION = {
    "", -- 10^0
    "K", -- 10^3
    "M", -- 10^6
    "B", -- 10^9
    "T", -- 10^12
    "Qa", -- 10^15
    "Qi", -- 10^18
    "Sx", -- 10^21
    "Sp", -- 10^24
    "Oc", -- 10^27
    "No", -- 10^30
    "De", -- 10^33
    "Ud", -- 10^36
    "Dd", -- 10^39
    "Td", -- 10^42
    "QaD", -- 10^45
    "QiD", -- 10^48
    "SxD", -- 10^51
    "SpD", -- 10^54
    "OcD", -- 10^57
    "NoD", -- 10^60
    
    "Vg", -- 10^63
    "UVg", -- 10^66
    "DVg", -- 10^69
    "TVg", -- 10^72
    "QaVg", -- 10^75
    "QiVg", -- 10^78
    "SxVg", -- 10^81
    "SpVg", -- 10^84
    "OcVg", -- 10^87
    "NoVg", -- 10^90
    
    "Tg", -- 10^93
    "UTg", -- 10^96
    "DTg", -- 10^99
    "TTg", -- 10^102
    "QaTg", -- 10^105
    "QiTg", -- 10^108
    "SxTg", -- 10^111
    "SpTg", -- 10^114
    "OcTg", -- 10^117
    "NoTg", -- 10^120
    
    "qg", -- 10^123
    "Uqg", -- 10^126
    "Dqg", -- 10^129
    "Tqg", -- 10^132
    "Qaqg", -- 10^135
    "Qiqg", -- 10^138
    "Sxqg", -- 10^141
    "Spqg", -- 10^144
    "Ocqg", -- 10^147
    "Noqg", -- 10^150
    
    "Qg", -- 10^153
    "UQg", -- 10^156
    "DQg", -- 10^159
    "TQg", -- 10^162
    "QaQg", -- 10^165
    "QiQg", -- 10^168
    "SxQg", -- 10^171
    "SpQg", -- 10^174
    "OcQg", -- 10^177
    "NoQg", -- 10^180
    
    "sg", -- 10^183
    "Usg", -- 10^186
    "Dsg", -- 10^189
    "Tsg", -- 10^192
    "Qasg", -- 10^195
    "Qisg", -- 10^198
    "Sxsg", -- 10^201
    "Spsg", -- 10^204
    "Ocsg", -- 10^207
    "Nosg", -- 10^210
    
    "Sg", -- 10^213
    "USg", -- 10^216
    "DSg", -- 10^219
    "TSg", -- 10^222
    "QaSg", -- 10^225
    "QiSg", -- 10^228
    "SxSg", -- 10^231
    "SpSg", -- 10^234
    "OcSg", -- 10^237
    "NoSg", -- 10^240
    
    "Og", -- 10^243
    "UOg", -- 10^246
    "DOg", -- 10^249
    "TOg", -- 10^252
    "QaOg", -- 10^255
    "QiOg", -- 10^258
    "SxOg", -- 10^261
    "SpOg", -- 10^264
    "OcOg", -- 10^267
    "NoOg", -- 10^270
    
    "Ng", -- 10^273
    "UNg", -- 10^276
    "DNg", -- 10^279
    "TNg", -- 10^282
    "QaNg", -- 10^285
    "QiNg", -- 10^288
    "SxNg", -- 10^291
    "SpNg", -- 10^294
    "OcNg", -- 10^297
    "NoNg", -- 10^300
    
    "Ce", -- 10^303
    "UCe", -- 10^306
    "DCe", -- 10^309
    "TgCe", -- 10^312
    "QaCe", -- 10^315
    "QiCe", -- 10^318
    "SxCe", -- 10^321
    "SpCe", -- 10^324
    "OcCe", -- 10^327
    "NoCe", -- 10^330
    
    "VgCe", -- 10^333
    "UVgCe", -- 10^336
    "DVgCe", -- 10^339
    "TVgCe", -- 10^342
    "QaVgCe", -- 10^345
    "QiVgCe", -- 10^348
    "SxVgCe", -- 10^351
    "SpVgCe", -- 10^354
    "OcVgCe", -- 10^357
    "NoVgCe", -- 10^360
    
    "TgCe", -- 10^363
    "UTgCe", -- 10^366
    "DTgCe", -- 10^369
    "TTgCe", -- 10^372
    "QaTgCe", -- 10^375
    "QiTgCe", -- 10^378
    "SxTgCe", -- 10^381
    "SpTgCe", -- 10^384
    "OcTgCe", -- 10^387
    "NoTgCe", -- 10^390
    
    "qgCe", -- 10^393
    "UqgCe", -- 10^396
    "DqgCe", -- 10^399
    "TqgCe", -- 10^402
    "QaqgCe", -- 10^405
    "QiqgCe", -- 10^408
    "SxqgCe", -- 10^411
    "SpqgCe", -- 10^414
    "OcqgCe", -- 10^417
    "NoqgCe", -- 10^420
    
    "QgCe", -- 10^423
    "UQgCe", -- 10^426
    "DQgCe", -- 10^429
    "TQgCe", -- 10^432
    "QaQgCe", -- 10^435
    "QiQgCe", -- 10^438
    "SxQgCe", -- 10^441
    "SpQgCe", -- 10^444
    "OcQgCe", -- 10^447
    "NoQgCe", -- 10^450
    
    "sgCe", -- 10^453
    "UsgCe", -- 10^456
    "DsgCe", -- 10^459
    "TsgCe", -- 10^462
    "QasgCe", -- 10^465
    "QisgCe", -- 10^468
    "SxsgCe", -- 10^471
    "SpsgCe", -- 10^474
    "OcsgCe", -- 10^477
    "NosgCe", -- 10^480
    
    "SgCe", -- 10^483
    "USgCe", -- 10^486
    "DSgCe", -- 10^489
    "TSgCe", -- 10^492
    "QaSgCe", -- 10^495
    "QiSgCe", -- 10^498
    "SxSgCe", -- 10^501
    "SpSgCe", -- 10^504
    "OcSgCe", -- 10^507
    "NoSgCe", -- 10^510
    
    "OgCe", -- 10^513
    "UOgCe", -- 10^516
    "DOgCe", -- 10^519
    "TOgCe", -- 10^522
    "QaOgCe", -- 10^525
    "QiOgCe", -- 10^528
    "SxOgCe", -- 10^531
    "SpOgCe", -- 10^534
    "OcOgCe", -- 10^537
    "NoOgCe", -- 10^540
    
    "NgCe", -- 10^543
    "UNgCe", -- 10^546
    "DNgCe", -- 10^549
    "TNgCe", -- 10^552
    "QaNgCe", -- 10^555
    "QiNgCe", -- 10^558
    "SxNgCe", -- 10^561
    "SpNgCe", -- 10^564
    "OcNgCe", -- 10^567
    "NoNgCe", -- 10^570
    
    "UCe", -- 10^573
    "UUCe", -- 10^576
    "DUCe", -- 10^579
    "TgUCe", -- 10^582
    "QaUCe", -- 10^585
    "QiUCe", -- 10^588
    "SxUCe", -- 10^591
    "SpUCe", -- 10^594
    "OcUCe", -- 10^597
    "NoUCe", -- 10^600
    
    "VgUCe", -- 10^603
    "UVgUCe", -- 10^606
    "DVgUCe", -- 10^609
    "TVgUCe", -- 10^612
    "QaVgUCe", -- 10^615
    "QiVgUCe", -- 10^618
    "SxVgUCe", -- 10^621
    "SpVgUCe", -- 10^624
    "OcVgUCe", -- 10^627
    "NoVgUCe", -- 10^630
    
    "TgUCe", -- 10^633
    "UTgUCe", -- 10^636
    "DTgUCe", -- 10^639
    "TTgUCe", -- 10^642
    "QaTgUCe", -- 10^645
    "QiTgUCe", -- 10^648
    "SxTgUCe", -- 10^651
    "SpTgUCe", -- 10^654
    "OcTgUCe", -- 10^657
    "NoTgUCe", -- 10^660
    
    "qgUCe", -- 10^663
    "UqgUCe", -- 10^666
    "DqgUCe", -- 10^669
    "TqgUCe", -- 10^672
    "QaqgUCe", -- 10^675
    "QiqgUCe", -- 10^678
    "SxqgUCe", -- 10^681
    "SpqgUCe", -- 10^684
    "OcqgUCe", -- 10^687
    "NoqgUCe", -- 10^690
    
    "QgUCe", -- 10^693
    "UQgUCe", -- 10^696
    "DQgUCe", -- 10^699
    "TQgUCe", -- 10^702
    "QaQgUCe", -- 10^705
    "QiQgUCe", -- 10^708
    "SxQgUCe", -- 10^711
    "SpQgUCe", -- 10^714
    "OcQgUCe", -- 10^717
    "NoQgUCe", -- 10^720
    
    "sgUCe", -- 10^723
    "UsgUCe", -- 10^726
    "DsgUCe", -- 10^729
    "TsgUCe", -- 10^732
    "QasgUCe", -- 10^735
    "QisgUCe", -- 10^738
    "SxsgUCe", -- 10^741
    "SpsgUCe", -- 10^744
    "OcsgUCe", -- 10^747
    "NosgUCe", -- 10^750
    
    "SgUCe", -- 10^753
    "USgUCe", -- 10^756
    "DSgUCe", -- 10^759
    "TSgUCe", -- 10^762
    "QaSgUCe", -- 10^765
    "QiSgUCe", -- 10^768
    "SxSgUCe", -- 10^771
    "SpSgUCe", -- 10^774
    "OcSgUCe", -- 10^777
    "NoSgUCe", -- 10^780
    
    "OgUCe", -- 10^783
    "UOgUCe", -- 10^786
    "DOgUCe", -- 10^789
    "TOgUCe", -- 10^792
    "QaOgUCe", -- 10^795
    "QiOgUCe", -- 10^798
    "SxOgUCe", -- 10^801
    "SpOgUCe", -- 10^804
    "OcOgUCe", -- 10^807
    "NoOgUCe", -- 10^810
    
    "NgUCe", -- 10^813
    "UNgUCe", -- 10^816
    "DNgUCe", -- 10^819
    "TNgUCe", -- 10^822
    "QaNgUCe", -- 10^825
    "QiNgUCe", -- 10^828
    "SxNgUCe", -- 10^831
    "SpNgUCe", -- 10^834
    "OcNgUCe", -- 10^837
    "NoNgUCe", -- 10^840
    
    "DCe", -- 10^843
    "UDCe", -- 10^846
    "DDCe", -- 10^849
    "TgDCe", -- 10^852
    "QaDCe", -- 10^855
    "QiDCe", -- 10^858
    "SxDCe", -- 10^861
    "SpDCe", -- 10^864
    "OcDCe", -- 10^867
    "NoDCe", -- 10^870
    
    "VgDCe", -- 10^873
    "UVgDCe", -- 10^876
    "DVgDCe", -- 10^879
    "TVgDCe", -- 10^882
    "QaVgDCe", -- 10^885
    "QiVgDCe", -- 10^888
    "SxVgDCe", -- 10^891
    "SpVgDCe", -- 10^894
    "OcVgDCe", -- 10^897
    "NoVgDCe", -- 10^900
    
    "TgDCe", -- 10^903
    "UTgDCe", -- 10^906
    "DTgDCe", -- 10^909
    "TTgDCe", -- 10^912
    "QaTgDCe", -- 10^915
    "QiTgDCe", -- 10^918
    "SxTgDCe", -- 10^921
    "SpTgDCe", -- 10^924
    "OcTgDCe", -- 10^927
    "NoTgDCe", -- 10^930
    
    "qgDCe", -- 10^933
    "UqgDCe", -- 10^936
    "DqgDCe", -- 10^939
    "TqgDCe", -- 10^942
    "QaqgDCe", -- 10^945
    "QiqgDCe", -- 10^948
    "SxqgDCe", -- 10^951
    "SpqgDCe", -- 10^954
    "OcqgDCe", -- 10^957
    "NoqgDCe", -- 10^960
    
    "QgDCe", -- 10^963
    "UQgDCe", -- 10^966
    "DQgDCe", -- 10^969
    "TQgDCe", -- 10^972
    "QaQgDCe", -- 10^975
    "QiQgDCe", -- 10^978
    "SxQgDCe", -- 10^981
    "SpQgDCe", -- 10^984
    "OcQgDCe", -- 10^987
    "NoQgDCe", -- 10^990
    
    "sgDCe", -- 10^993
    "UsgDCe", -- 10^996
    "DsgDCe", -- 10^999
    "TsgDCe", -- 10^1002
    "QasgDCe", -- 10^1005
    "QisgDCe", -- 10^1008
    "SxsgDCe", -- 10^1011
    "SpsgDCe", -- 10^1014
    "OcsgDCe", -- 10^1017
    "NosgDCe", -- 10^1020
    
    "SgDCe", -- 10^1023
    "USgDCe", -- 10^1026
    "DSgDCe", -- 10^1029
    "TSgDCe", -- 10^1032
    "QaSgDCe", -- 10^1035
    "QiSgDCe", -- 10^1038
    "SxSgDCe", -- 10^1041
    "SpSgDCe", -- 10^1044
    "OcSgDCe", -- 10^1047
    "NoSgDCe", -- 10^1050
    
    "OgDCe", -- 10^1053
    "UOgDCe", -- 10^1056
    "DOgDCe", -- 10^1059
    "TOgDCe", -- 10^1062
    "QaOgDCe", -- 10^1065
    "QiOgDCe", -- 10^1068
    "SxOgDCe", -- 10^1071
    "SpOgDCe", -- 10^1074
    "OcOgDCe", -- 10^1077
    "NoOgDCe", -- 10^1080
    
    "NgDCe", -- 10^1083
    "UNgDCe", -- 10^1086
    "DNgDCe", -- 10^1089
    "TNgDCe", -- 10^1092
    "QaNgDCe", -- 10^1095
    "QiNgDCe", -- 10^1098
    "SxNgDCe", -- 10^1101
    "SpNgDCe", -- 10^1104
    "OcNgDCe", -- 10^1107
    "NoNgDCe", -- 10^1110
    
    "TCe", -- 10^1113
    "UTCe", -- 10^1116
    "DTCe", -- 10^1119
    "TTCe", -- 10^1122
    "QaTCe", -- 10^1125
    "QiTCe", -- 10^1128
    "SxTCe", -- 10^1131
    "SpTCe", -- 10^1134
    "OcTCe", -- 10^1137
    "NoTCe", -- 10^1140
    
    "VgTCe", -- 10^1143
    "UVgTCe", -- 10^1146
    "DVgTCe", -- 10^1149
    "TVgTCe", -- 10^1152
    "QaVgTCe", -- 10^1155
    "QiVgTCe", -- 10^1158
    "SxVgTCe", -- 10^1161
    "SpVgTCe", -- 10^1164
    "OcVgTCe", -- 10^1167
    "NoVgTCe", -- 10^1170
    
    "TgTCe", -- 10^1173
    "UTgTCe", -- 10^1176
    "DTgTCe", -- 10^1179
    "TTgTCe", -- 10^1182
    "QaTgTCe", -- 10^1185
    "QiTgTCe", -- 10^1188
    "SxTgTCe", -- 10^1191
    "SpTgTCe", -- 10^1194
    "OcTgTCe", -- 10^1197
    "NoTgTCe", -- 10^1200
    
    "qgTCe", -- 10^1203
    "UqgTCe", -- 10^1206
    "DqgTCe", -- 10^1209
    "TqgTCe", -- 10^1212
    "QaqgTCe", -- 10^1215
    "QiqgTCe", -- 10^1218
    "SxqgTCe", -- 10^1221
    "SpqgTCe", -- 10^1224
    "OcqgTCe", -- 10^1227
    "NoqgTCe", -- 10^1230
    
    "QgTCe", -- 10^1233
    "UQgTCe", -- 10^1236
    "DQgTCe", -- 10^1239
    "TQgTCe", -- 10^1242
    "QaQgTCe", -- 10^1245
    "QiQgTCe", -- 10^1248
    "SxQgTCe", -- 10^1251
    "SpQgTCe", -- 10^1254
    "OcQgTCe", -- 10^1257
    "NoQgTCe", -- 10^1260
    
    "sgTCe", -- 10^1263
    "UsgTCe", -- 10^1266
    "DsgTCe", -- 10^1269
    "TsgTCe", -- 10^1272
    "QasgTCe", -- 10^1275
    "QisgTCe", -- 10^1278
    "SxsgTCe", -- 10^1281
    "SpsgTCe", -- 10^1284
    "OcsgTCe", -- 10^1287
    "NosgTCe", -- 10^1290
    
    "SgTCe", -- 10^1293
    "USgTCe", -- 10^1296
    "DSgTCe", -- 10^1299
    "TSgTCe", -- 10^1302
    "QaSgTCe", -- 10^1305
    "QiSgTCe", -- 10^1308
    "SxSgTCe", -- 10^1311
    "SpSgTCe", -- 10^1314
    "OcSgTCe", -- 10^1317
    "NoSgTCe", -- 10^1320
    
    "OgTCe", -- 10^1323
    "UOgTCe", -- 10^1326
    "DOgTCe", -- 10^1329
    "TOgTCe", -- 10^1332
    "QaOgTCe", -- 10^1335
    "QiOgTCe", -- 10^1338
    "SxOgTCe", -- 10^1341
    "SpOgTCe", -- 10^1344
    "OcOgTCe", -- 10^1347
    "NoOgTCe", -- 10^1350
    
    "NgTCe", -- 10^1353
    "UNgTCe", -- 10^1356
    "DNgTCe", -- 10^1359
    "TNgTCe", -- 10^1362
    "QaNgTCe", -- 10^1365
    "QiNgTCe", -- 10^1368
    "SxNgTCe", -- 10^1371
    "SpNgTCe", -- 10^1374
    "OcNgTCe", -- 10^1377
    "NoNgTCe", -- 10^1380
    
    "QaCe", -- 10^1383
    "UQaCe", -- 10^1386
    "DQaCe", -- 10^1389
    "TQaCe", -- 10^1392
    "QaQaCe", -- 10^1395
    "QiQaCe", -- 10^1398
    "SxQaCe", -- 10^1401
    "SpQaCe", -- 10^1404
    "OcQaCe", -- 10^1407
    "NoQaCe", -- 10^1410
    
    "VgQaCe", -- 10^1413
    "UVgQaCe", -- 10^1416
    "DVgQaCe", -- 10^1419
    "TVgQaCe", -- 10^1422
    "QaVgQaCe", -- 10^1425
    "QiVgQaCe", -- 10^1428
    "SxVgQaCe", -- 10^1431
    "SpVgQaCe", -- 10^1434
    "OcVgQaCe", -- 10^1437
    "NoVgQaCe", -- 10^1440
    
    "TgQaCe", -- 10^1443
    "UTgQaCe", -- 10^1446
    "DTgQaCe", -- 10^1449
    "TTgQaCe", -- 10^1452
    "QaTgQaCe", -- 10^1455
    "QiTgQaCe", -- 10^1458
    "SxTgQaCe", -- 10^1461
    "SpTgQaCe", -- 10^1464
    "OcTgQaCe", -- 10^1467
    "NoTgQaCe", -- 10^1470
    
    "qgQaCe", -- 10^1473
    "UqgQaCe", -- 10^1476
    "DqgQaCe", -- 10^1479
    "TqgQaCe", -- 10^1482
    "QaqgQaCe", -- 10^1485
    "QiqgQaCe", -- 10^1488
    "SxqgQaCe", -- 10^1491
    "SpqgQaCe", -- 10^1494
    "OcqgQaCe", -- 10^1497
    "NoqgQaCe", -- 10^1500
    
    "QgQaCe", -- 10^1503
    "UQgQaCe", -- 10^1506
    "DQgQaCe", -- 10^1509
    "TQgQaCe", -- 10^1512
    "QaQgQaCe", -- 10^1515
    "QiQgQaCe", -- 10^1518
    "SxQgQaCe", -- 10^1521
    "SpQgQaCe", -- 10^1524
    "OcQgQaCe", -- 10^1527
    "NoQgQaCe", -- 10^1530
    
    "sgQaCe", -- 10^1533
    "UsgQaCe", -- 10^1536
    "DsgQaCe", -- 10^1539
    "TsgQaCe", -- 10^1542
    "QasgQaCe", -- 10^1545
    "QisgQaCe", -- 10^1548
    "SxsgQaCe", -- 10^1551
    "SpsgQaCe", -- 10^1554
    "OcsgQaCe", -- 10^1557
    "NosgQaCe", -- 10^1560
    
    "SgQaCe", -- 10^1563
    "USgQaCe", -- 10^1566
    "DSgQaCe", -- 10^1569
    "TSgQaCe", -- 10^1572
    "QaSgQaCe", -- 10^1575
    "QiSgQaCe", -- 10^1578
    "SxSgQaCe", -- 10^1581
    "SpSgQaCe", -- 10^1584
    "OcSgQaCe", -- 10^1587
    "NoSgQaCe", -- 10^1590
    
    "OgQaCe", -- 10^1593
    "UOgQaCe", -- 10^1596
    "DOgQaCe", -- 10^1599
    "TOgQaCe", -- 10^1602
    "QaOgQaCe", -- 10^1605
    "QiOgQaCe", -- 10^1608
    "SxOgQaCe", -- 10^1611
    "SpOgQaCe", -- 10^1614
    "OcOgQaCe", -- 10^1617
    "NoOgQaCe", -- 10^1620
    
    "NgQaCe", -- 10^1623
    "UNgQaCe", -- 10^1626
    "DNgQaCe", -- 10^1629
    "TNgQaCe", -- 10^1632
    "QaNgQaCe", -- 10^1635
    "QiNgQaCe", -- 10^1638
    "SxNgQaCe", -- 10^1641
    "SpNgQaCe", -- 10^1644
    "OcNgQaCe", -- 10^1647
    "NoNgQaCe", -- 10^1650
    
    "QiCe", -- 10^1653
    "UQiCe", -- 10^1656
    "DQiCe", -- 10^1659
    "TQiCe", -- 10^1662
    "QaQiCe", -- 10^1665
    "QiQiCe", -- 10^1668
    "SxQiCe", -- 10^1671
    "SpQiCe", -- 10^1674
    "OcQiCe", -- 10^1677
    "NoQiCe", -- 10^1680
    
    "VgQiCe", -- 10^1683
    "UVgQiCe", -- 10^1686
    "DVgQiCe", -- 10^1689
    "TVgQiCe", -- 10^1692
    "QaVgQiCe", -- 10^1695
    "QiVgQiCe", -- 10^1698
    "SxVgQiCe", -- 10^1701
    "SpVgQiCe", -- 10^1704
    "OcVgQiCe", -- 10^1707
    "NoVgQiCe", -- 10^1710
    
    "TgQiCe", -- 10^1713
    "UTgQiCe", -- 10^1716
    "DTgQiCe", -- 10^1719
    "TTgQiCe", -- 10^1722
    "QaTgQiCe", -- 10^1725
    "QiTgQiCe", -- 10^1728
    "SxTgQiCe", -- 10^1731
    "SpTgQiCe", -- 10^1734
    "OcTgQiCe", -- 10^1737
    "NoTgQiCe", -- 10^1740
    
    "qgQiCe", -- 10^1743
    "UqgQiCe", -- 10^1746
    "DqgQiCe", -- 10^1749
    "TqgQiCe", -- 10^1752
    "QaqgQiCe", -- 10^1755
    "QiqgQiCe", -- 10^1758
    "SxqgQiCe", -- 10^1761
    "SpqgQiCe", -- 10^1764
    "OcqgQiCe", -- 10^1767
    "NoqgQiCe", -- 10^1770
    
    "QgQiCe", -- 10^1773
    "UQgQiCe", -- 10^1776
    "DQgQiCe", -- 10^1779
    "TQgQiCe", -- 10^1782
    "QaQgQiCe", -- 10^1785
    "QiQgQiCe", -- 10^1788
    "SxQgQiCe", -- 10^1791
    "SpQgQiCe", -- 10^1794
    "OcQgQiCe", -- 10^1797
    "NoQgQiCe", -- 10^1800
    
    "sgQiCe", -- 10^1803
    "UsgQiCe", -- 10^1806
    "DsgQiCe", -- 10^1809
    "TsgQiCe", -- 10^1812
    "QasgQiCe", -- 10^1815
    "QisgQiCe", -- 10^1818
    "SxsgQiCe", -- 10^1821
    "SpsgQiCe", -- 10^1824
    "OcsgQiCe", -- 10^1827
    "NosgQiCe", -- 10^1830
    
    "SgQiCe", -- 10^1833
    "USgQiCe", -- 10^1836
    "DSgQiCe", -- 10^1839
    "TSgQiCe", -- 10^1842
    "QaSgQiCe", -- 10^1845
    "QiSgQiCe", -- 10^1848
    "SxSgQiCe", -- 10^1851
    "SpSgQiCe", -- 10^1854
    "OcSgQiCe", -- 10^1857
    "NoSgQiCe", -- 10^1860
    
    "OgQiCe", -- 10^1863
    "UOgQiCe", -- 10^1866
    "DOgQiCe", -- 10^1869
    "TOgQiCe", -- 10^1872
    "QaOgQiCe", -- 10^1875
    "QiOgQiCe", -- 10^1878
    "SxOgQiCe", -- 10^1881
    "SpOgQiCe", -- 10^1884
    "OcOgQiCe", -- 10^1887
    "NoOgQiCe", -- 10^1890
    
    "NgQiCe", -- 10^1893
    "UNgQiCe", -- 10^1896
    "DNgQiCe", -- 10^1899
    "TNgQiCe", -- 10^1902
    "QaNgQiCe", -- 10^1905
    "QiNgQiCe", -- 10^1908
    "SxNgQiCe", -- 10^1911
    "SpNgQiCe", -- 10^1914
    "OcNgQiCe", -- 10^1917
    "NoNgQiCe", -- 10^1920
    
    "SxCe", -- 10^1923
    "USxCe", -- 10^1926
    "DSxCe", -- 10^1929
    "TSxCe", -- 10^1932
    "QaSxCe", -- 10^1935
    "QiSxCe", -- 10^1938
    "SxSxCe", -- 10^1941
    "SpSxCe", -- 10^1944
    "OcSxCe", -- 10^1947
    "NoSxCe", -- 10^1950
    
    "VgSxCe", -- 10^1953
    "UVgSxCe", -- 10^1956
    "DVgSxCe", -- 10^1959
    "TVgSxCe", -- 10^1962
    "QaVgSxCe", -- 10^1965
    "QiVgSxCe", -- 10^1968
    "SxVgSxCe", -- 10^1971
    "SpVgSxCe", -- 10^1974
    "OcVgSxCe", -- 10^1977
    "NoVgSxCe", -- 10^1980
    
    "TgSxCe", -- 10^1983
    "UTgSxCe", -- 10^1986
    "DTgSxCe", -- 10^1989
    "TTgSxCe", -- 10^1992
    "QaTgSxCe", -- 10^1995
    "QiTgSxCe", -- 10^1998
    "SxTgSxCe", -- 10^2001
    "SpTgSxCe", -- 10^2004
    "OcTgSxCe", -- 10^2007
    "NoTgSxCe", -- 10^2010
    
    "qgSxCe", -- 10^2013
    "UqgSxCe", -- 10^2016
    "DqgSxCe", -- 10^2019
    "TqgSxCe", -- 10^2022
    "QaqgSxCe", -- 10^2025
    "QiqgSxCe", -- 10^2028
    "SxqgSxCe", -- 10^2031
    "SpqgSxCe", -- 10^2034
    "OcqgSxCe", -- 10^2037
    "NoqgSxCe", -- 10^2040
    
    "QgSxCe", -- 10^2043
    "UQgSxCe", -- 10^2046
    "DQgSxCe", -- 10^2049
    "TQgSxCe", -- 10^2052
    "QaQgSxCe", -- 10^2055
    "QiQgSxCe", -- 10^2058
    "SxQgSxCe", -- 10^2061
    "SpQgSxCe", -- 10^2064
    "OcQgSxCe", -- 10^2067
    "NoQgSxCe", -- 10^2070
    
    "sgSxCe", -- 10^2073
    "UsgSxCe", -- 10^2076
    "DsgSxCe", -- 10^2079
    "TsgSxCe", -- 10^2082
    "QasgSxCe", -- 10^2085
    "QisgSxCe", -- 10^2088
    "SxsgSxCe", -- 10^2091
    "SpsgSxCe", -- 10^2094
    "OcsgSxCe", -- 10^2097
    "NosgSxCe", -- 10^2100
    
    "SgSxCe", -- 10^2103
    "USgSxCe", -- 10^2106
    "DSgSxCe", -- 10^2109
    "TSgSxCe", -- 10^2112
    "QaSgSxCe", -- 10^2115
    "QiSgSxCe", -- 10^2118
    "SxSgSxCe", -- 10^2121
    "SpSgSxCe", -- 10^2124
    "OcSgSxCe", -- 10^2127
    "NoSgSxCe", -- 10^2130
    
    "OgSxCe", -- 10^2133
    "UOgSxCe", -- 10^2136
    "DOgSxCe", -- 10^2139
    "TOgSxCe", -- 10^2142
    "QaOgSxCe", -- 10^2145
    "QiOgSxCe", -- 10^2148
    "SxOgSxCe", -- 10^2151
    "SpOgSxCe", -- 10^2154
    "OcOgSxCe", -- 10^2157
    "NoOgSxCe", -- 10^2160
    
    "NgSxCe", -- 10^2163
    "UNgSxCe", -- 10^2166
    "DNgSxCe", -- 10^2169
    "TNgSxCe", -- 10^2172
    "QaNgSxCe", -- 10^2175
    "QiNgSxCe", -- 10^2178
    "SxNgSxCe", -- 10^2181
    "SpNgSxCe", -- 10^2184
    "OcNgSxCe", -- 10^2187
    "NoNgSxCe", -- 10^2190
    
    "SpCe", -- 10^2193
    "USpCe", -- 10^2196
    "DSpCe", -- 10^2199
    "TSpCe", -- 10^2202
    "QaSpCe", -- 10^2205
    "QiSpCe", -- 10^2208
    "SxSpCe", -- 10^2211
    "SpSpCe", -- 10^2214
    "OcSpCe", -- 10^2217
    "NoSpCe", -- 10^2220
    
    "VgSpCe", -- 10^2223
    "UVgSpCe", -- 10^2226
    "DVgSpCe", -- 10^2229
    "TVgSpCe", -- 10^2232
    "QaVgSpCe", -- 10^2235
    "QiVgSpCe", -- 10^2238
    "SxVgSpCe", -- 10^2241
    "SpVgSpCe", -- 10^2244
    "OcVgSpCe", -- 10^2247
    "NoVgSpCe", -- 10^2250
    
    "TgSpCe", -- 10^2253
    "UTgSpCe", -- 10^2256
    "DTgSpCe", -- 10^2259
    "TTgSpCe", -- 10^2262
    "QaTgSpCe", -- 10^2265
    "QiTgSpCe", -- 10^2268
    "SxTgSpCe", -- 10^2271
    "SpTgSpCe", -- 10^2274
    "OcTgSpCe", -- 10^2277
    "NoTgSpCe", -- 10^2280
    
    "qgSpCe", -- 10^2283
    "UqgSpCe", -- 10^2286
    "DqgSpCe", -- 10^2289
    "TqgSpCe", -- 10^2292
    "QaqgSpCe", -- 10^2295
    "QiqgSpCe", -- 10^2298
    "SxqgSpCe", -- 10^2301
    "SpqgSpCe", -- 10^2304
    "OcqgSpCe", -- 10^2307
    "NoqgSpCe", -- 10^2310
    
    "QgSpCe", -- 10^2313
    "UQgSpCe", -- 10^2316
    "DQgSpCe", -- 10^2319
    "TQgSpCe", -- 10^2322
    "QaQgSpCe", -- 10^2325
    "QiQgSpCe", -- 10^2328
    "SxQgSpCe", -- 10^2331
    "SpQgSpCe", -- 10^2334
    "OcQgSpCe", -- 10^2337
    "NoQgSpCe", -- 10^2340
    
    "sgSpCe", -- 10^2343
    "UsgSpCe", -- 10^2346
    "DsgSpCe", -- 10^2349
    "TsgSpCe", -- 10^2352
    "QasgSpCe", -- 10^2355
    "QisgSpCe", -- 10^2358
    "SxsgSpCe", -- 10^2361
    "SpsgSpCe", -- 10^2364
    "OcsgSpCe", -- 10^2367
    "NosgSpCe", -- 10^2370
    
    "SgSpCe", -- 10^2373
    "USgSpCe", -- 10^2376
    "DSgSpCe", -- 10^2379
    "TSgSpCe", -- 10^2382
    "QaSgSpCe", -- 10^2385
    "QiSgSpCe", -- 10^2388
    "SxSgSpCe", -- 10^2391
    "SpSgSpCe", -- 10^2394
    "OcSgSpCe", -- 10^2397
    "NoSgSpCe", -- 10^2400
    
    "OgSpCe", -- 10^2403
    "UOgSpCe", -- 10^2406
    "DOgSpCe", -- 10^2409
    "TOgSpCe", -- 10^2412
    "QaOgSpCe", -- 10^2415
    "QiOgSpCe", -- 10^2418
    "SxOgSpCe", -- 10^2421
    "SpOgSpCe", -- 10^2424
    "OcOgSpCe", -- 10^2427
    "NoOgSpCe", -- 10^2430
    
    "NgSpCe", -- 10^2433
    "UNgSpCe", -- 10^2436
    "DNgSpCe", -- 10^2439
    "TNgSpCe", -- 10^2442
    "QaNgSpCe", -- 10^2445
    "QiNgSpCe", -- 10^2448
    "SxNgSpCe", -- 10^2451
    "SpNgSpCe", -- 10^2454
    "OcNgSpCe", -- 10^2457
    "NoNgSpCe", -- 10^2460
    
    "OcCe", -- 10^2463
    "UOcCe", -- 10^2466
    "DOcCe", -- 10^2469
    "TOcCe", -- 10^2472
    "QaOcCe", -- 10^2475
    "QiOcCe", -- 10^2478
    "SxOcCe", -- 10^2481
    "SpOcCe", -- 10^2484
    "OcOcCe", -- 10^2487
    "NoOcCe", -- 10^2490
    
    "VgOcCe", -- 10^2493
    "UVgOcCe", -- 10^2496
    "DVgOcCe", -- 10^2499
    "TVgOcCe", -- 10^2502
    "QaVgOcCe", -- 10^2505
    "QiVgOcCe", -- 10^2508
    "SxVgOcCe", -- 10^2511
    "SpVgOcCe", -- 10^2514
    "OcVgOcCe", -- 10^2517
    "NoVgOcCe", -- 10^2520
    
    "TgOcCe", -- 10^2523
    "UTgOcCe", -- 10^2526
    "DTgOcCe", -- 10^2529
    "TTgOcCe", -- 10^2532
    "QaTgOcCe", -- 10^2535
    "QiTgOcCe", -- 10^2538
    "SxTgOcCe", -- 10^2541
    "SpTgOcCe", -- 10^2544
    "OcTgOcCe", -- 10^2547
    "NoTgOcCe", -- 10^2550
    
    "qgOcCe", -- 10^2553
    "UqgOcCe", -- 10^2556
    "DqgOcCe", -- 10^2559
    "TqgOcCe", -- 10^2562
    "QaqgOcCe", -- 10^2565
    "QiqgOcCe", -- 10^2568
    "SxqgOcCe", -- 10^2571
    "SpqgOcCe", -- 10^2574
    "OcqgOcCe", -- 10^2577
    "NoqgOcCe", -- 10^2580
    
    "QgOcCe", -- 10^2583
    "UQgOcCe", -- 10^2586
    "DQgOcCe", -- 10^2589
    "TQgOcCe", -- 10^2592
    "QaQgOcCe", -- 10^2595
    "QiQgOcCe", -- 10^2598
    "SxQgOcCe", -- 10^2601
    "SpQgOcCe", -- 10^2604
    "OcQgOcCe", -- 10^2607
    "NoQgOcCe", -- 10^2610
    
    "sgOcCe", -- 10^2613
    "UsgOcCe", -- 10^2616
    "DsgOcCe", -- 10^2619
    "TsgOcCe", -- 10^2622
    "QasgOcCe", -- 10^2625
    "QisgOcCe", -- 10^2628
    "SxsgOcCe", -- 10^2631
    "SpsgOcCe", -- 10^2634
    "OcsgOcCe", -- 10^2637
    "NosgOcCe", -- 10^2640
    
    "SgOcCe", -- 10^2643
    "USgOcCe", -- 10^2646
    "DSgOcCe", -- 10^2649
    "TSgOcCe", -- 10^2652
    "QaSgOcCe", -- 10^2655
    "QiSgOcCe", -- 10^2658
    "SxSgOcCe", -- 10^2661
    "SpSgOcCe", -- 10^2664
    "OcSgOcCe", -- 10^2667
    "NoSgOcCe", -- 10^2670
    
    "OgOcCe", -- 10^2673
    "UOgOcCe", -- 10^2676
    "DOgOcCe", -- 10^2679
    "TOgOcCe", -- 10^2682
    "QaOgOcCe", -- 10^2685
    "QiOgOcCe", -- 10^2688
    "SxOgOcCe", -- 10^2691
    "SpOgOcCe", -- 10^2694
    "OcOgOcCe", -- 10^2697
    "NoOgOcCe", -- 10^2700
    
    "NgOcCe", -- 10^2703
    "UNgOcCe", -- 10^2706
    "DNgOcCe", -- 10^2709
    "TNgOcCe", -- 10^2712
    "QaNgOcCe", -- 10^2715
    "QiNgOcCe", -- 10^2718
    "SxNgOcCe", -- 10^2721
    "SpNgOcCe", -- 10^2724
    "OcNgOcCe", -- 10^2727
    "NoNgOcCe", -- 10^2730
    
    "NoCe", -- 10^2733
    "UNoCe", -- 10^2736
    "DNoCe", -- 10^2739
    "TNoCe", -- 10^2742
    "QaNoCe", -- 10^2745
    "QiNoCe", -- 10^2748
    "SxNoCe", -- 10^2751
    "SpNoCe", -- 10^2754
    "OcNoCe", -- 10^2757
    "NoNoCe", -- 10^2760
    
    "VgNoCe", -- 10^2763
    "UVgNoCe", -- 10^2766
    "DVgNoCe", -- 10^2769
    "TVgNoCe", -- 10^2772
    "QaVgNoCe", -- 10^2775
    "QiVgNoCe", -- 10^2778
    "SxVgNoCe", -- 10^2781
    "SpVgNoCe", -- 10^2784
    "OcVgNoCe", -- 10^2787
    "NoVgNoCe", -- 10^2790
    
    "TgNoCe", -- 10^2793
    "UTgNoCe", -- 10^2796
    "DTgNoCe", -- 10^2799
    "TTgNoCe", -- 10^2802
    "QaTgNoCe", -- 10^2805
    "QiTgNoCe", -- 10^2808
    "SxTgNoCe", -- 10^2811
    "SpTgNoCe", -- 10^2814
    "OcTgNoCe", -- 10^2817
    "NoTgNoCe", -- 10^2820
    
    "qgNoCe", -- 10^2823
    "UqgNoCe", -- 10^2826
    "DqgNoCe", -- 10^2829
    "TqgNoCe", -- 10^2832
    "QaqgNoCe", -- 10^2835
    "QiqgNoCe", -- 10^2838
    "SxqgNoCe", -- 10^2841
    "SpqgNoCe", -- 10^2844
    "OcqgNoCe", -- 10^2847
    "NoqgNoCe", -- 10^2850
    
    "QgNoCe", -- 10^2853
    "UQgNoCe", -- 10^2856
    "DQgNoCe", -- 10^2859
    "TQgNoCe", -- 10^2862
    "QaQgNoCe", -- 10^2865
    "QiQgNoCe", -- 10^2868
    "SxQgNoCe", -- 10^2871
    "SpQgNoCe", -- 10^2874
    "OcQgNoCe", -- 10^2877
    "NoQgNoCe", -- 10^2880
    
    "sgNoCe", -- 10^2883
    "UsgNoCe", -- 10^2886
    "DsgNoCe", -- 10^2889
    "TsgNoCe", -- 10^2892
    "QasgNoCe", -- 10^2895
    "QisgNoCe", -- 10^2898
    "SxsgNoCe", -- 10^2901
    "SpsgNoCe", -- 10^2904
    "OcsgNoCe", -- 10^2907
    "NosgNoCe", -- 10^2910
    
    "SgNoCe", -- 10^2913
    "USgNoCe", -- 10^2916
    "DSgNoCe", -- 10^2919
    "TSgNoCe", -- 10^2922
    "QaSgNoCe", -- 10^2925
    "QiSgNoCe", -- 10^2928
    "SxSgNoCe", -- 10^2931
    "SpSgNoCe", -- 10^2934
    "OcSgNoCe", -- 10^2937
    "NoSgNoCe", -- 10^2940
    
    "OgNoCe", -- 10^2943
    "UOgNoCe", -- 10^2946
    "DOgNoCe", -- 10^2949
    "TOgNoCe", -- 10^2952
    "QaOgNoCe", -- 10^2955
    "QiOgNoCe", -- 10^2958
    "SxOgNoCe", -- 10^2961
    "SpOgNoCe", -- 10^2964
    "OcOgNoCe", -- 10^2967
    "NoOgNoCe", -- 10^2970
    
    "NgNoCe", -- 10^2973
    "UNgNoCe", -- 10^2976
    "DNgNoCe", -- 10^2979
    "TNgNoCe", -- 10^2982
    "QaNgNoCe", -- 10^2985
    "QiNgNoCe", -- 10^2988
    "SxNgNoCe", -- 10^2991
    "SpNgNoCe", -- 10^2994
    "OcNgNoCe", -- 10^2997
    "NoNgNoCe", -- 10^3000
    
    "Mi", -- 10^3003
}

-- Base-90 character set (exactly 90 printable ASCII characters)
local CHARACTERS = {
    "0","1","2","3","4","5","6","7","8","9",
    "a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z",
    "A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z",
    "!","#","$","%","&","'","(",")","*","+",".","/",":",";","<","=",">","?","@","[","]","^","_","`","{","}","|","~"
}

local MAX_TIER = #NOTATION

-- Performance optimizations: caching built-in functions for faster access.
local math_floor    = math.floor
local math_abs      = math.abs
local math_log10    = math.log10
local string_rep    = string.rep
local string_format = string.format
local string_sub    = string.sub
local string_gsub   = string.gsub
local string_match  = string.match
local string_gmatch = string.gmatch
local table_concat  = table.concat
local table_insert  = table.insert
local table_create  = table.create or function(size) return {} end

local base = #CHARACTERS  -- Base-90 encoding

--------------------------------------------------------------------------------
-- Utility: normalizeNumber
-- Purpose: Normalize a number represented as blocks (groups of up to 3 digits) by 
--          calculating its overall magnitude (number of digits) and ensuring a consistent
--          structure for arithmetic operations.
--
-- Parameters:
--   num - table with the following keys:
--         blocks    : array of numbers (each block represents three digits, least-significant first)
--         sign      : (optional) sign of the number (1 for positive, -1 for negative; default is 1)
--         magnitude : (optional) pre-computed digit count; if not provided, it's computed.
--
-- Example:
--   Input: { sign = 1, blocks = {500, 1} } (which represents 1500)
--   Output: { sign = 1, blocks = {500, 1}, magnitude = 4 }   (since "1500" has 4 digits)
--------------------------------------------------------------------------------
function Banana.normalizeNumber(num)
    local blocks = num.blocks or {}
    local sign = num.sign or 1
    local magnitude = num.magnitude

    if not magnitude then
        local firstNonZero = nil
        for i = #blocks, 1, -1 do
            if blocks[i] ~= 0 then
                firstNonZero = i
                -- Use the sign of the most significant non-zero block
                sign = blocks[i] < 0 and -1 or 1
                break
            end
        end
        
        if not firstNonZero then
            magnitude = 1  -- Represents zero
        else
            magnitude = (firstNonZero - 1) * 3
            for i = firstNonZero, 1, -1 do
                local absVal = math_abs(blocks[i])
                if absVal > 0 then
                    magnitude = magnitude + math_floor(math_log10(absVal)) + 1
                    break
                end
            end
        end
    end

    return {
        sign = sign,
        blocks = blocks,
        magnitude = magnitude
    }
end

--------------------------------------------------------------------------------
-- Comparison: compare
-- Purpose: Compare two normalized numbers and determine their relational order.
--
-- Parameters:
--   a, b - normalized number tables (each with sign and blocks).
--
-- Returns:
--   1 if a > b,
--  -1 if a < b,
--   0 if they are equal.
--
-- Example:
--   a = { sign = 1, blocks = {5, 3} } which represents 3500
--   b = { sign = 1, blocks = {3, 7} } which represents 7300
--   compare(a,b) returns -1 because 3500 < 7300.
--------------------------------------------------------------------------------
function Banana.compare(a, b)
    if a.sign ~= b.sign then
        return a.sign > b.sign and 1 or -1
    end

    local lenA, lenB = #a.blocks, #b.blocks
    if lenA ~= lenB then
        return (lenA > lenB and 1 or -1) * a.sign
    end

    for i = lenA, 1, -1 do
        if a.blocks[i] ~= b.blocks[i] then
            return (a.blocks[i] > b.blocks[i] and 1 or -1) * a.sign
        end
    end

    return 0  -- They are equal.
end

--------------------------------------------------------------------------------
-- Arithmetic: add
-- Purpose: Add two normalized numbers together.
--
-- Parameters:
--   a, b - normalized number tables.
--
-- Returns:
--   A new normalized number representing the sum.
--
-- Example:
--   a = { sign = 1, blocks = {500} } representing 500
--   b = { sign = -1, blocks = {300} } representing -300
--   add(a,b) returns { sign = 1, blocks = {200} } representing 200.
--------------------------------------------------------------------------------
function Banana.add(a, b)
    -- If signs differ, perform subtraction instead.
    if a.sign ~= b.sign then
        -- Create a copy of b with flipped sign to avoid mutating the input.
        local bNeg = { sign = -b.sign, blocks = {} }
        for i = 1, #b.blocks do
            bNeg.blocks[i] = b.blocks[i]
        end
        return Banana.subtract(a, bNeg)
    end

    local result = {}
    local carry = 0
    local maxLen = math.max(#a.blocks, #b.blocks)

    for i = 1, maxLen do
        local sum = (a.blocks[i] or 0) + (b.blocks[i] or 0) + carry
        carry = math_floor(sum / 1000)
        result[i] = sum % 1000
    end

    if carry > 0 then
        result[maxLen + 1] = carry
    end

    return Banana.normalizeNumber({ sign = a.sign, blocks = result })
end

--------------------------------------------------------------------------------
-- Arithmetic: subtract
-- Purpose: Subtract one normalized number from another (a - b).
--
-- Parameters:
--   a, b - normalized number tables.
--
-- Returns:
--   A new normalized number representing the difference.
--
-- Example:
--   a = { sign = 1, blocks = {500} } (500)
--   b = { sign = 1, blocks = {300} } (300)
--   subtract(a, b) returns { sign = 1, blocks = {200} } (200)
--------------------------------------------------------------------------------
function Banana.subtract(a, b)
    if a.sign ~= b.sign then
        -- If signs differ, treat it as addition.
        local bNeg = { sign = -b.sign, blocks = {} }
        for i = 1, #b.blocks do
            bNeg.blocks[i] = b.blocks[i]
        end
        return Banana.add(a, bNeg)
    end

    local absCompare = Banana.compare(
        { sign = 1, blocks = a.blocks },
        { sign = 1, blocks = b.blocks }
    )

    if absCompare < 0 then
        -- If |a| < |b|, swap arguments and flip the sign of the result.
        local result = Banana.subtract(b, a)
        result.sign = -result.sign
        return result
    end

    local result = {}
    local borrow = 0

    for i = 1, #a.blocks do
        local aVal = a.blocks[i]
        local bVal = b.blocks[i] or 0
        local diff = aVal - bVal - borrow

        if diff < 0 then
            diff = diff + 1000
            borrow = 1
        else
            borrow = 0
        end

        result[i] = diff
    end

    return Banana.normalizeNumber({ sign = a.sign, blocks = result })
end

--------------------------------------------------------------------------------
-- Conversion: stringToNumber
-- Purpose: Convert a decimal string into a normalized number.
--          This also tracks the magnitude (number of digits) accurately.
--
-- Parameters:
--   str - string representing the decimal number (may include commas, spaces, or a decimal point).
--
-- Returns:
--   A normalized number table with sign, blocks, and magnitude.
--
-- Example:
--   Input: "1500000000000000"
--   Output: { sign = 1, blocks = {calculated blocks}, magnitude = 15 }
--------------------------------------------------------------------------------
function Banana.stringToNumber(str)
    str = string_gsub(str, "[%s,]", "")
    local sign = 1

    -- Handle negative sign
    if string_sub(str, 1, 1) == "-" then
        sign = -1
        str = string_sub(str, 2)
    end

    -- Split into whole and optional decimal parts
    local whole, decimal = str:match("^(%d*)%.?(%d*)")
    whole = whole or ""
    decimal = decimal or ""

    -- Combine the parts and remove leading zeros.
    local combined = whole .. decimal
    combined = string_gsub(combined, "^0+", "")
    if combined == "" then combined = "0" end

    -- Calculate the magnitude (number of digits)
    local magnitude = #combined + (#decimal > 0 and #decimal or 0) - 1

    -- Break the number into 3-digit blocks (least-significant first)
    local padded = combined:reverse()
    padded = padded .. string_rep("0", (3 - #padded % 3) % 3)

    local blocks = {}
    for i = 1, #padded, 3 do
        local chunk = string_sub(padded, i, i + 2):reverse()
        table_insert(blocks, tonumber(chunk))
    end

    return Banana.normalizeNumber({ sign = sign, blocks = blocks, magnitude = magnitude })
end

--[[
  Function: Banana.notationToString
  Purpose:  Convert a shorthand number notation into its full string representation.
            For example, "1.5K" becomes "1500", and "-2.3M" becomes "-2300000".
  Parameters:
    str - A shorthand notation string (e.g., "-1.5K").
  
  Returns:
    A string representing the full number in decimal notation.
    If the input format is not as expected or the suffix is unknown, returns the input unmodified.
--]]
function Banana.notationToString(str)
    -- Remove spaces and commas for easy parsing.
    str = str:gsub("[%s,]", "")
    
    -- Check for and extract an optional leading negative sign.
    local sign = ""
    if str:sub(1, 1) == "-" then
        sign = "-"
        str = str:sub(2)
    end
    
    -- Extract the numeric part (which can include a decimal point) and the suffix.
    local numberPart, suffix = str:match("^([%d%.]+)(%a+)$")
    if not numberPart or not suffix then
        -- If the pattern doesn't match, return the original string (with sign reattached).
        return sign .. str
    end

    -- Normalize the suffix to lower-case.
    suffix = suffix:lower()

    -- Find the index of the suffix in the NOTATION table.
    local index
    if NOTATION and type(NOTATION) == "table" then
        for i, s in ipairs(NOTATION) do
            -- Compare case-insensitively.
            if s:lower() == suffix then
                index = i
                break
            end
        end
    end

    -- If suffix not found in NOTATION, return the original string.
    if not index then
        return sign .. str
    end

    -- Each tier (index-1) represents a factor of 10^3 (i.e., three orders of magnitude).
    local exponent = (index - 1) * 3

    -- Separate the number part into integer and fractional components.
    local integerPart, fractionalPart = numberPart:match("^(%d*)%.?(%d*)$")
    fractionalPart = fractionalPart or ""
    
    -- Count the digits after the decimal.
    local fractionalDigits = #fractionalPart

    -- Calculate how many zeros must be appended or adjust decimal placement.
    local effectiveExponent = exponent - fractionalDigits

    -- Combine integer and fractional parts, removing leading zeros.
    local combined = (integerPart or "") .. fractionalPart
    combined = combined:gsub("^0+", "")
    if combined == "" then combined = "0" end

    if effectiveExponent < 0 then
        -- Handle negative effectiveExponent by inserting decimal point
        local totalDigits = #combined
        local decimalPosition = totalDigits + effectiveExponent

        if decimalPosition <= 0 then
            -- Case where we need leading zeros: e.g., "0.00123"
            combined = "0." .. string.rep("0", -decimalPosition) .. combined
        else
            -- Insert decimal point within the combined digits
            combined = combined:sub(1, decimalPosition) .. "." .. combined:sub(decimalPosition + 1)
        end

        -- Trim trailing zeros after decimal
        combined = combined:gsub("%.?0+$", "")
        if combined:sub(-1) == "." then
            combined = combined:sub(1, -2)
        end
    else
        -- Append zeros for positive effectiveExponent
        combined = combined .. string.rep("0", effectiveExponent)
    end

    -- Reattach the negative sign if necessary
    return sign .. combined
end

--------------------------------------------------------------------------------
-- Formatting Helper: getSuffix
-- Purpose: Return the appropriate suffix based on the number of blocks.
--
-- Parameters:
--   blockCount - number of blocks representing the magnitude tier.
--
-- Returns:
--   A string suffix from the NOTATION table.
--
-- Example:
--   If blockCount is 4 and NOTATION[5] is "T", then getSuffix(4) returns "T".
--------------------------------------------------------------------------------
local function getSuffix(blockCount)
    local tier = math.min(blockCount, MAX_TIER)
    return NOTATION[tier] or ""
end

--------------------------------------------------------------------------------
-- Formatting: formatNumber
-- Purpose: Format a normalized number into a string with a suffix,
--          using a tiered notation (each tier corresponds to 10^3).
--
-- Parameters:
--   num      - normalized number table.
--   decimals - number of decimal places to show.
--
-- Returns:
--   A formatted string.
--
-- Example:
--   For a number with magnitude 15 representing 1.5e15, this function could return "1.5Qa" 
--   if NOTATION[6] is "Qa".
--------------------------------------------------------------------------------
local function formatNumber(num, decimals)
    if #num.blocks == 0 or (num.blocks[1] == 0 and #num.blocks == 1) then
        return "0"
    end

    -- Calculate tier based on the magnitude.
    local tier = math.floor(num.magnitude / 3)
    tier = math.min(tier + 1, #NOTATION)  -- Adjust for 1-based index

    -- If the magnitude exceeds our notation definitions, handle overflow.
    if tier > #NOTATION then
        local overflowTier = #NOTATION
        local overflowValue = num.magnitude - (overflowTier - 1) * 3
        return string_format("%.1f%se+%d", 
            10^(overflowValue % 3), 
            NOTATION[overflowTier],
            math_floor(overflowValue / 3) * 3
        )
    end

    local suffix = NOTATION[tier]

    -- Calculate the displayed value starting with the most significant block.
    local value = num.blocks[#num.blocks] or 0
    if num.magnitude % 3 ~= 0 then
        value = value * 10^(3 - (num.magnitude % 3))
    end

    -- Incorporate a sub-block (if available) to show decimals.
    local subBlock = num.blocks[#num.blocks - 1] or 0
    value = value + subBlock / 1000
    if value >= 1000 and tier < #NOTATION then
        tier = tier + 1
        suffix = NOTATION[tier]
        value = value / 1000
    end

    local formatted = string_format("%." .. decimals .. "f", value)
    formatted = string_gsub(formatted, "%.?0+$", "")

    return (num.sign < 0 and "-" or "") .. formatted .. suffix
end

--------------------------------------------------------------------------------
-- Formatting: getShort
-- Purpose: Provides a concise representation of a number.
--
-- Example:
--   Given a normalized number for 1500, getShort returns something like "1.5K".
--------------------------------------------------------------------------------
function Banana.getShort(num)
    return formatNumber(num, 1)
end

--------------------------------------------------------------------------------
-- Formatting: getMedium
-- Purpose: Provides a medium-length representation of a number.
--
-- Example:
--   For 1500, getMedium might return "1.50K" (showing two decimals).
--------------------------------------------------------------------------------
function Banana.getMedium(num)
    return formatNumber(num, 2)
end

--------------------------------------------------------------------------------
-- Formatting: getDetailed
-- Purpose: Provides a detailed representation of a number including more decimal places.
--
-- Example:
--   For 1500, getDetailed might return "1.500K" (showing three decimals).
--------------------------------------------------------------------------------
function Banana.getDetailed(num)
    return formatNumber(num, 3)
end

--------------------------------------------------------------------------------
-- Base Conversion: encodeNumber
-- Purpose: Convert a decimal string into its Base-90 encoded representation.
--
-- Parameters:
--   value - string representing a decimal number.
--
-- Returns:
--   A string representing the encoded number in Base-90.
--
-- Example:
--   Input: "901"
--   Calculation: 901 = 10*90 + 1 
--   Output: "a1" (assuming "a" maps to 10 in the CHARACTERS array).
--------------------------------------------------------------------------------
function Banana.encodeNumber(value)
    local num = Banana.stringToNumber(value)
    if num.blocks[1] == 0 and #num.blocks == 1 then
        return "0"
    end

    local current = num.blocks
    local chars = {}

    while Banana.compare({ sign = 1, blocks = current }, { sign = 1, blocks = {0} }) > 0 do
        local remainder = 0
        local newBlocks = {}

        for i = #current, 1, -1 do
            local val = current[i] + remainder * 1000
            local quotient = math_floor(val / base)
            remainder = val % base

            if #newBlocks > 0 or quotient > 0 then
                table_insert(newBlocks, 1, quotient)
            end
        end

        table_insert(chars, 1, CHARACTERS[remainder + 1])
        current = newBlocks
    end

    return (num.sign < 0 and "-" or "") .. table_concat(chars)
end

function Banana.decodeNumber(encodedStr)
    if encodedStr == "0" then
        return "0"
    end

    local sign = 1
    local str = encodedStr
    if str:sub(1, 1) == "-" then
        sign = -1
        str = str:sub(2)
        if str == "" then
            return "0"
        end
    end

    local blocks = {0}

    for i = 1, #str do
        local c = str:sub(i, i)
        local charIndex
        for idx, ch in ipairs(CHARACTERS) do
            if ch == c then
                charIndex = idx
                break
            end
        end
        if not charIndex then
            error("Invalid character in encoded string: " .. c)
        end
        local value = charIndex - 1

        -- Multiply current blocks by 90
        local newBlocks = {}
        local carry = 0
        for j = 1, #blocks do
            local product = blocks[j] * 90 + carry
            carry = math_floor(product / 1000)
            newBlocks[j] = product % 1000
        end
        local len = #newBlocks
        while carry > 0 do
            len = len + 1
            newBlocks[len] = carry % 1000
            carry = math_floor(carry / 1000)
        end
        blocks = newBlocks

        -- Add value to the first block and handle carry
        if #blocks == 0 then
            blocks[1] = value
        else
            blocks[1] = blocks[1] + value
            carry = math_floor(blocks[1] / 1000)
            blocks[1] = blocks[1] % 1000
            local j = 2
            while carry > 0 and j <= #blocks do
                blocks[j] = blocks[j] + carry
                carry = math_floor(blocks[j] / 1000)
                blocks[j] = blocks[j] % 1000
                j = j + 1
            end
            if carry > 0 then
                blocks[j] = carry
            end
        end
    end

    -- Convert blocks to string
    local reversedBlocks = {}
    for i = #blocks, 1, -1 do
        table_insert(reversedBlocks, blocks[i])
    end

    local parts = {}
    for i, block in ipairs(reversedBlocks) do
        if i == 1 then
            table_insert(parts, string_format("%d", block))
        else
            table_insert(parts, string_format("%03d", block))
        end
    end

    local numberStr = table_concat(parts)
    numberStr = numberStr:gsub("^0+", "")
    if numberStr == "" then
        numberStr = "0"
    end

    if sign == -1 and numberStr ~= "0" then
        numberStr = "-" .. numberStr
    end

    return numberStr
end

--------------------------------------------------------------------------------
-- Setup: configureNotation
-- Purpose: Allow customization of the magnitude suffix notation.
--
-- Parameters:
--   newNotation - array of suffix strings to override the default notation.
--   suffixMap   - (optional) table to remap specific suffix positions.
--
-- Example:
--   Calling Banana.configureNotation({"", "K", "M"}, {[2]=6}) would set up the notation
--   so that the second suffix ("K") corresponds to a magnitude level of 6 instead of 3.
--------------------------------------------------------------------------------
function Banana.configureNotation(newNotation, suffixMap)
    NOTATION = newNotation or NOTATION
    MAX_TIER = #NOTATION

    -- Rebuild suffix lookup (useful for possible future extensions)
    local suffixLookup = {}
    for i, v in ipairs(NOTATION) do
        if v ~= "" then
            suffixLookup[v:lower()] = suffixMap and suffixMap[i] or (i - 1) * 3
        end
    end
end

--------------------------------------------------------------------------------
-- Comparison: IsGreater
-- Purpose: Check if the first number is greater than the second.
-- Parameters:
--   a, b - normalized number tables.
-- Returns: true if a > b, false otherwise.
--------------------------------------------------------------------------------
function Banana.IsGreater(a, b)
    return Banana.compare(a, b) == 1
end

--------------------------------------------------------------------------------
-- Comparison: IsLesser
-- Purpose: Check if the first number is less than the second.
-- Parameters:
--   a, b - normalized number tables.
-- Returns: true if a < b, false otherwise.
--------------------------------------------------------------------------------
function Banana.IsLesser(a, b)
    return Banana.compare(a, b) == -1
end

--------------------------------------------------------------------------------
-- Comparison: IsEqual
-- Purpose: Check if two numbers are equal.
-- Parameters:
--   a, b - normalized number tables.
-- Returns: true if a == b, false otherwise.
--------------------------------------------------------------------------------
function Banana.IsEqual(a, b)
    return Banana.compare(a, b) == 0
end

--------------------------------------------------------------------------------
-- Comparison: IsGreaterThanOrEqual
-- Purpose: Check if the first number is greater than or equal to the second.
-- Parameters:
--   a, b - normalized number tables.
-- Returns: true if a >= b, false otherwise.
--------------------------------------------------------------------------------
function Banana.IsGreaterThanOrEqual(a, b)
    return Banana.compare(a, b) >= 0
end

--------------------------------------------------------------------------------
-- Comparison: IsLesserThanOrEqual
-- Purpose: Check if the first number is less than or equal to the second.
-- Parameters:
--   a, b - normalized number tables.
-- Returns: true if a <= b, false otherwise.
--------------------------------------------------------------------------------
function Banana.IsLesserThanOrEqual(a, b)
    return Banana.compare(a, b) <= 0
end

return Banana