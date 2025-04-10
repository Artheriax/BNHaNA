local Gigantix = {}

-- Notation table for suffixes used in short notation

local NOTATION = {
    -- Basic and early large numbers:
    "",     -- 10^0    (One)
    "K",    -- 10^3    (Thousand)
    "M",    -- 10^6    (Million)
    "B",    -- 10^9    (Billion)
    "T",    -- 10^12   (Trillion)
    "Qa",   -- 10^15   (Quadrillion)
    "Qi",   -- 10^18   (Quintillion)
    "Sx",   -- 10^21   (Sextillion)
    "Sp",   -- 10^24   (Septillion)
    "Oc",   -- 10^27   (Octillion)
    "No",   -- 10^30   (Nonillion)

    "De",   -- 10^33   (Decillion)
    "UD",   -- 10^36   (Undecillion)
    "DD",   -- 10^39   (Duodecillion)
    "TD",   -- 10^42   (Tredecillion)
    "QaD",  -- 10^45   (Quattuordecillion)
    "QiD",  -- 10^48   (Quindecillion)
    "SxD",  -- 10^51   (Sexdecillion)
    "SpD",  -- 10^54   (Septendecillion)
    "OcD",  -- 10^57   (Octodecillion)
    "NoD",  -- 10^60   (Novemdecillion)

    "Vg",   -- 10^63   (Vggintillion)
    "UVg",  -- 10^66   (Unvigintillion)
    "DVg",  -- 10^69   (Duovigintillion)
    "TVg",  -- 10^72   (Trevigintillion)
    "QaVg", -- 10^75   (Quattuorvigintillion)
    "QiVg", -- 10^78   (Quinvigintillion)
    "SxVg", -- 10^81   (Sexvigintillion)
    "SpVg", -- 10^84   (Septenvigintillion)
    "OcVg", -- 10^87   (Octovigintillion)
    "NoVg", -- 10^90   (Novemvigintillion)

    -- Trigintillion family (10^93 to 10^120):
    "Tg",    -- 10^93   (Trigintillion)
    "UTg",   -- 10^96   (Untrigintillion)
    "DTg",   -- 10^99   (Duotrigintillion)
    "TTg",   -- 10^102  (Tretrigintillion)
    "QaTg",  -- 10^105  (Quattuortrigintillion)
    "QiTg",  -- 10^108  (Quintrigintillion)
    "SxTg",  -- 10^111  (Sextrigintillion)
    "SpTg",  -- 10^114  (Septentrigintillion)
    "OcTg",  -- 10^117  (Octotrigintillion)
    "NoTg",  -- 10^120  (Novemtrigintillion),

    -- Quadragintillion family (10^123 to 10^150):
    "qg",   -- 10^123  (Quadragintillion)
    "Uqg",  -- 10^126  (Unquadragintillion)
    "Dqg",  -- 10^129  (Duoquadragintillion)
    "Tqg",  -- 10^132  (Trequadragintillion)
    "Qaqg", -- 10^135  (Quattuorquadragintillion)
    "Qiqg", -- 10^138  (Quinquadragintillion)
    "Sxqg", -- 10^141  (Sexquadragintillion)
    "Spqg", -- 10^144  (Septenquadragintillion)
    "Ocqg", -- 10^147  (Octoquadragintillion)
    "Noqg", -- 10^150  (Novemquadragintillion),

    -- Quinquagintillion family (10^153 to 10^180):
    "Qg",   -- 10^153  (Quinquagintillion)
    "UQg",  -- 10^156  (Unquinquagintillion)
    "DQg",  -- 10^159  (Duoquinquagintillion)
    "TQg",  -- 10^162  (Trequinquagintillion)
    "QaQg", -- 10^165  (Quattuorquinquagintillion)
    "QiQg", -- 10^168  (Quinquinquagintillion)
    "SxQg", -- 10^171  (Sexquinquagintillion)
    "SpQg", -- 10^174  (Septenquinquagintillion)
    "OcQg", -- 10^177  (Octoquinquagintillion)
    "NoQg", -- 10^180  (Novemquinquagintillion),

    -- Sexagintillion family (10^183 to 10^210):
    "sg",   -- 10^183  (Sexagintillion)
    "Usg",  -- 10^186  (Unsexagintillion)
    "Dsg",  -- 10^189  (Duosexagintillion)
    "Tsg",  -- 10^192  (Tresexagintillion)
    "Qasg", -- 10^195  (Quattuorsexagintillion)
    "Qisg", -- 10^198  (Quinsexagintillion)
    "Sxsg", -- 10^201  (Sexsexagintillion)
    "Spsg", -- 10^204  (Septensexagintillion)
    "Ocsg", -- 10^207  (Octosexagintillion)
    "Nosg", -- 10^210  (Novemsexagintillion),

    -- Septuagintillion family (10^213 to 10^240):
    "Sg",    -- 10^213  (Septuagintillion)
    "USg",   -- 10^216  (Unseptuagintillion)
    "DSg",   -- 10^219  (Duoseptuagintillion)
    "TSg",   -- 10^222  (Treseptuagintillion)
    "QaSg",  -- 10^225  (Quattuorseptuagintillion)
    "QiSg",  -- 10^228  (Quinseptuagintillion)
    "SxSg",  -- 10^231  (Sexseptuagintillion)
    "SpSg",  -- 10^234  (Septenseptuagintillion)
    "OcSg",  -- 10^237  (Octoseptuagintillion)
    "NoSg",  -- 10^240  (Novemseptuagintillion),

    -- Octogintillion family (10^243 to 10^270):
    "Og",    -- 10^243  (Octogintillion)
    "UOg",   -- 10^246  (Unoctogintillion)
    "DOg",   -- 10^249  (Duooctogintillion)
    "TOg",   -- 10^252  (Treoctogintillion)
    "QaOg",  -- 10^255  (Quattuoroctogintillion)
    "QiOg",  -- 10^258  (Quinoctogintillion)
    "SxOg",  -- 10^261  (Sexoctogintillion)
    "SpOg",  -- 10^264  (Septenoctogintillion)
    "OcOg",  -- 10^267  (Octooctogintillion)
    "NoOg",  -- 10^270  (Novemoctogintillion),

    -- Nonagintillion family (10^273 to 10^300):
    "Ng",    -- 10^273  (Nonagintillion)
    "UNg",   -- 10^276  (Unnonagintillion)
    "DNg",   -- 10^279  (Duononagintillion)
    "TNg",   -- 10^282  (Trenonagintillion)
    "QaNg",  -- 10^285  (Quattuornonagintillion)
    "QiNg",  -- 10^288  (Quinnonagintillion)
    "SxNg",  -- 10^291  (Sexnonagintillion)
    "SpNg",  -- 10^294  (Septennonagintillion)
    "OcNg",  -- 10^297  (Octononagintillion)
    "NoNg",  -- 10^300  (Novemnonagintillion),

    -- Centillion family (10^303 to 10^360):
    "Ce",    -- 10^303  (Centillion)
    "UCe",   -- 10^306  (Uncentillion)
    "DCe",   -- 10^309  (Duocentillion)
    "TgCe",   -- 10^312  (Trescentillion)
    "QaCe",  -- 10^315  (Quattuorcentillion)
    "QiCe",  -- 10^318  (Quincentillion)
    "SxCe",  -- 10^321  (Sexcentillion)
    "SpCe",  -- 10^324  (Septencentillion)
    "OcCe",  -- 10^327  (Octocentillion)
    "NoCe",  -- 10^330  (Novemcentillion)

    "DeCe",  -- 10^333  (Decicentillion)
    "UDeCe", -- 10^336  (Undecicentillion)
    "TDeCe", -- 10^339  (Tredecicentillion)
    "QaDeCe",-- 10^342  (Quattuordecicentillion)
    "QiDeCe",-- 10^345  (Quindecicentillion)
    "SxDeCe",-- 10^348  (Sedecicentillion)
    "SpDeCe",-- 10^351  (Septendecicentillion)
    "OcDeCe",-- 10^354  (Octodecicentillion)
    "NoDeCe",-- 10^357  (Novemdecicentillion)

    -- Viginticentillion group (10^363 to 10^390):
    "VgCe",  -- 10^360  (Vgginticentillion),
    "UVgCe",  -- 10^363  (Unviginticentillion)
    "DVgCe",  -- 10^366  (Duoviginticentillion)
    "TVgCe",  -- 10^369  (Treviginticentillion)
    "QaVgCe", -- 10^372  (Quattuorviginticentillion)
    "QiVgCe", -- 10^375  (Quinviginticentillion)
    "SxVgCe", -- 10^378  (Sexviginticentillion)
    "SpVgCe", -- 10^381  (Septenviginticentillion)
    "OcVgCe", -- 10^384  (Octoviginticentillion)
    "NoVgCe", -- 10^387  (Novemviginticentillion),

    -- Triginticentillion group (10^393 to 10^420):
    "TgCe",    -- 10^393  (Triginticentillion)
    "UTgCe",   -- 10^396  (Untriginticentillion)
    "DTgCe",   -- 10^399  (Duotriginticentillion)
    "TTgCe",   -- 10^402  (Tretriginticentillion)
    "QaTgCe",  -- 10^405  (Quattuortriginticentillion)
    "QiTgCe",  -- 10^408  (Quintriginticentillion)
    "SxTgCe",  -- 10^411  (Sextriginticentillion)
    "SpTgCe",  -- 10^414  (Septentriginticentillion)
    "OcTgCe",  -- 10^417  (Octotriginticentillion)
    "NoTgCe",  -- 10^420  (Novemtriginticentillion),

    -- Quadragintacentillion group (10^423 to 10^450):
    "qgCe",   -- 10^423  (Quadragintacentillion)
    "UqgCe",  -- 10^426  (Unquadragintacentillion)
    "DqgCe",  -- 10^429  (Duoquadragintacentillion)
    "TqgCe",  -- 10^432  (Trequadragintacentillion)
    "QaqgCe", -- 10^435  (Quattuorquadragintacentillion)
    "QiqgCe", -- 10^438  (Quinquadragintacentillion)
    "SxqgCe", -- 10^441  (Sexquadragintacentillion)
    "SpqgCe", -- 10^444  (Septenquadragintacentillion)
    "OcqgCe", -- 10^447  (Octoquadragintacentillion)
    "NoqgCe", -- 10^450  (Novemquadragintacentillion),

    -- Quinquagintacentillion group (10^453 to 10^480):
    "QgCe",   -- 10^453  (Quinquagintacentillion)
    "UQgCe",  -- 10^456  (Unquinquagintacentillion)
    "DQgCe",  -- 10^459  (Duoquinquagintacentillion)
    "TQgCe",  -- 10^462  (Trequinquagintacentillion)
    "QaQgCe", -- 10^465  (Quattuorquinquagintacentillion)
    "QiQgCe", -- 10^468  (Quinquinquagintacentillion)
    "SxQgCe", -- 10^471  (Sexquinquagintacentillion)
    "SpQgCe", -- 10^474  (Septenquinquagintacentillion)
    "OcQgCe", -- 10^477  (Octoquinquagintacentillion)
    "NoQgCe", -- 10^480  (Novemquinquagintacentillion),

    -- Sexagintacentillion group (10^483 to 10^510):
    "sgCe",   -- 10^483  (Sexagintacentillion)
    "UsgCe",  -- 10^486  (Unsexagintacentillion)
    "DsgCe",  -- 10^489  (Duosexagintacentillion)
    "TsgCe",  -- 10^492  (Tresexagintacentillion)
    "QasgCe", -- 10^495  (Quattuorsexagintacentillion)
    "QisgCe", -- 10^498  (Quinsexagintacentillion)
    "SxsgCe", -- 10^501  (Sexsexagintacentillion)
    "SpsgCe", -- 10^504  (Septensexagintacentillion)
    "OcsgCe", -- 10^507  (Octosexagintacentillion)
    "NosgCe", -- 10^510  (Novemsexagintacentillion),

    -- Septuacentillion group (10^513 to 10^540):
    "SgCe",   -- 10^513  (Septuacentillion)
    "USgCe",  -- 10^516  (Unseptuacentillion)
    "DSgCe",  -- 10^519  (Duoseptuacentillion)
    "TSgCe",  -- 10^522  (Treseptuacentillion)
    "QaSgCe", -- 10^525  (Quattuorseptuacentillion)
    "QiSgCe", -- 10^528  (Quinseptuacentillion)
    "SxSgCe", -- 10^531  (Sexseptuacentillion)
    "SpSgCe", -- 10^534  (Septenseptuacentillion)
    "OcSgCe", -- 10^537  (Octoseptuacentillion)
    "NoSgCe", -- 10^540  (Novemseptuacentillion),

    -- Octogintacentillion group (10^543 to 10^570):
    "OgCe",   -- 10^543  (Octogintacentillion)
    "UOgCe",  -- 10^546  (Unoctogintacentillion)
    "DOgCe",  -- 10^549  (Duooctogintacentillion)
    "TOgCe",  -- 10^552  (Treoctogintacentillion)
    "QaOgCe", -- 10^555  (Quattuoroctogintacentillion)
    "QiOgCe", -- 10^558  (Quinoctogintacentillion)
    "SxOgCe", -- 10^561  (Sexoctogintacentillion)
    "SpOgCe", -- 10^564  (Septenoctogintacentillion)
    "OcOgCe", -- 10^567  (Octooctogintacentillion)
    "NoOgCe", -- 10^570  (Novemoctogintacentillion),

    -- Nonagintacentillion group (10^573 to 10^600):
    "NgCe",   -- 10^573  (Nonagintacentillion)
    "UNgCe",  -- 10^576  (Unnonagintacentillion)
    "DNgCe",  -- 10^579  (Duononagintacentillion)
    "TNgCe",  -- 10^582  (Trenonagintacentillion)
    "QaNgCe", -- 10^585  (Quattuornonagintacentillion)
    "QiNgCe", -- 10^588  (Quinnonagintacentillion)
    "SxNgCe", -- 10^591  (Sexnonagintacentillion)
    "SpNgCe", -- 10^594  (Septennonagintacentillion)
    "OcNgCe", -- 10^597  (Octononagintacentillion)
    "NoNgCe", -- 10^600  (Novemnonagintacentillion),

    "UCe",    -- 10^303  (Centillion)
    "UUCe",   -- 10^306  (Uncentillion)
    "DUCe",   -- 10^309  (Duocentillion)
    "TgUCe",   -- 10^312  (Trescentillion)
    "QaUCe",  -- 10^315  (Quattuorcentillion)
    "QiUCe",  -- 10^318  (Quincentillion)
    "SxUCe",  -- 10^321  (Sexcentillion)
    "SpUCe",  -- 10^324  (Septencentillion)
    "OcUCe",  -- 10^327  (Octocentillion)
    "NoUCe",  -- 10^330  (Novemcentillion)

    "DeUCe",  -- 10^333  (Decicentillion)
    "UDeUCe", -- 10^336  (Undecicentillion)
    "TDeUCe", -- 10^339  (Tredecicentillion)
    "QaDeUCe",-- 10^342  (Quattuordecicentillion)
    "QiDeUCe",-- 10^345  (Quindecicentillion)
    "SxDeUCe",-- 10^348  (Sedecicentillion)
    "SpDeUCe",-- 10^351  (Septendecicentillion)
    "OcDeUCe",-- 10^354  (Octodecicentillion)
    "NoDeUCe",-- 10^357  (Novemdecicentillion)

    -- Viginticentillion group (10^363 to 10^390):
    "VgUCe",  -- 10^360  (Vgginticentillion),
    "UVgUCe",  -- 10^363  (Unviginticentillion)
    "DVgUCe",  -- 10^366  (Duoviginticentillion)
    "TVgUCe",  -- 10^369  (Treviginticentillion)
    "QaVgUCe", -- 10^372  (Quattuorviginticentillion)
    "QiVgUCe", -- 10^375  (Quinviginticentillion)
    "SxVgUCe", -- 10^378  (Sexviginticentillion)
    "SpVgUCe", -- 10^381  (Septenviginticentillion)
    "OcVgUCe", -- 10^384  (Octoviginticentillion)
    "NoVgUCe", -- 10^387  (Novemviginticentillion),

    -- Triginticentillion group (10^393 to 10^420):
    "TgUCe",    -- 10^393  (Triginticentillion)
    "UTgUCe",   -- 10^396  (Untriginticentillion)
    "DTgUCe",   -- 10^399  (Duotriginticentillion)
    "TTgUCe",   -- 10^402  (Tretriginticentillion)
    "QaTgUCe",  -- 10^405  (Quattuortriginticentillion)
    "QiTgUCe",  -- 10^408  (Quintriginticentillion)
    "SxTgUCe",  -- 10^411  (Sextriginticentillion)
    "SpTgUCe",  -- 10^414  (Septentriginticentillion)
    "OcTgUCe",  -- 10^417  (Octotriginticentillion)
    "NoTgUCe",  -- 10^420  (Novemtriginticentillion),

    -- Quadragintacentillion group (10^423 to 10^450):
    "qgUCe",   -- 10^423  (Quadragintacentillion)
    "UqgUCe",  -- 10^426  (Unquadragintacentillion)
    "DqgUCe",  -- 10^429  (Duoquadragintacentillion)
    "TqgUCe",  -- 10^432  (Trequadragintacentillion)
    "QaqgUCe", -- 10^435  (Quattuorquadragintacentillion)
    "QiqgUCe", -- 10^438  (Quinquadragintacentillion)
    "SxqgUCe", -- 10^441  (Sexquadragintacentillion)
    "SpqgUCe", -- 10^444  (Septenquadragintacentillion)
    "OcqgUCe", -- 10^447  (Octoquadragintacentillion)
    "NoqgUCe", -- 10^450  (Novemquadragintacentillion),

    -- Quinquagintacentillion group (10^453 to 10^480):
    "QgUCe",   -- 10^453  (Quinquagintacentillion)
    "UQgUCe",  -- 10^456  (Unquinquagintacentillion)
    "DQgUCe",  -- 10^459  (Duoquinquagintacentillion)
    "TQgUCe",  -- 10^462  (Trequinquagintacentillion)
    "QaQgUCe", -- 10^465  (Quattuorquinquagintacentillion)
    "QiQgUCe", -- 10^468  (Quinquinquagintacentillion)
    "SxQgUCe", -- 10^471  (Sexquinquagintacentillion)
    "SpQgUCe", -- 10^474  (Septenquinquagintacentillion)
    "OcQgUCe", -- 10^477  (Octoquinquagintacentillion)
    "NoQgUCe", -- 10^480  (Novemquinquagintacentillion),

    -- Sexagintacentillion group (10^483 to 10^510):
    "sgUCe",   -- 10^483  (Sexagintacentillion)
    "UsgUCe",  -- 10^486  (Unsexagintacentillion)
    "DsgUCe",  -- 10^489  (Duosexagintacentillion)
    "TsgUCe",  -- 10^492  (Tresexagintacentillion)
    "QasgUCe", -- 10^495  (Quattuorsexagintacentillion)
    "QisgUCe", -- 10^498  (Quinsexagintacentillion)
    "SxsgUCe", -- 10^501  (Sexsexagintacentillion)
    "SpsgUCe", -- 10^504  (Septensexagintacentillion)
    "OcsgUCe", -- 10^507  (Octosexagintacentillion)
    "NosgUCe", -- 10^510  (Novemsexagintacentillion),

    -- Septuacentillion group (10^513 to 10^540):
    "SgUCe",   -- 10^513  (Septuacentillion)
    "USgUCe",  -- 10^516  (Unseptuacentillion)
    "DSgUCe",  -- 10^519  (Duoseptuacentillion)
    "TSgUCe",  -- 10^522  (Treseptuacentillion)
    "QaSgUCe", -- 10^525  (Quattuorseptuacentillion)
    "QiSgUCe", -- 10^528  (Quinseptuacentillion)
    "SxSgUCe", -- 10^531  (Sexseptuacentillion)
    "SpSgUCe", -- 10^534  (Septenseptuacentillion)
    "OcSgUCe", -- 10^537  (Octoseptuacentillion)
    "NoSgUCe", -- 10^540  (Novemseptuacentillion),

    -- Octogintacentillion group (10^543 to 10^570):
    "OgUCe",   -- 10^543  (Octogintacentillion)
    "UOgUCe",  -- 10^546  (Unoctogintacentillion)
    "DOgUCe",  -- 10^549  (Duooctogintacentillion)
    "TOgUCe",  -- 10^552  (Treoctogintacentillion)
    "QaOgUCe", -- 10^555  (Quattuoroctogintacentillion)
    "QiOgUCe", -- 10^558  (Quinoctogintacentillion)
    "SxOgUCe", -- 10^561  (Sexoctogintacentillion)
    "SpOgUCe", -- 10^564  (Septenoctogintacentillion)
    "OcOgUCe", -- 10^567  (Octooctogintacentillion)
    "NoOgUCe", -- 10^570  (Novemoctogintacentillion),

    -- Nonagintacentillion group (10^573 to 10^600):
    "NgUCe",   -- 10^573  (Nonagintacentillion)
    "UNgUCe",  -- 10^576  (Unnonagintacentillion)
    "DNgUCe",  -- 10^579  (Duononagintacentillion)
    "TNgUCe",  -- 10^582  (Trenonagintacentillion)
    "QaNgUCe", -- 10^585  (Quattuornonagintacentillion)
    "QiNgUCe", -- 10^588  (Quinnonagintacentillion)
    "SxNgUCe", -- 10^591  (Sexnonagintacentillion)
    "SpNgUCe", -- 10^594  (Septennonagintacentillion)
    "OcNgUCe", -- 10^597  (Octononagintacentillion)
    "NoNgUCe", -- 10^600  (Novemnonagintacentillion),

    "DCe",    -- 10^303  (Centillion)
    "UDCe",   -- 10^306  (Uncentillion)
    "DDCe",   -- 10^309  (Duocentillion)
    "TgDCe",   -- 10^312  (Trescentillion)
    "QaDCe",  -- 10^315  (Quattuorcentillion)
    "QiDCe",  -- 10^318  (Quincentillion)
    "SxDCe",  -- 10^321  (Sexcentillion)
    "SpDCe",  -- 10^324  (Septencentillion)
    "OcDCe",  -- 10^327  (Octocentillion)
    "NoDCe",  -- 10^330  (Novemcentillion)

    "DeDCe",  -- 10^333  (Decicentillion)
    "UDeDCe", -- 10^336  (Undecicentillion)
    "TDeDCe", -- 10^339  (Tredecicentillion)
    "QaDeDCe",-- 10^342  (Quattuordecicentillion)
    "QiDeDCe",-- 10^345  (Quindecicentillion)
    "SxDeDCe",-- 10^348  (Sedecicentillion)
    "SpDeDCe",-- 10^351  (Septendecicentillion)
    "OcDeDCe",-- 10^354  (Octodecicentillion)
    "NoDeDCe",-- 10^357  (Novemdecicentillion)

    -- Viginticentillion group (10^363 to 10^390):
    "VgDCe",  -- 10^360  (Vgginticentillion),
    "UVgDCe",  -- 10^363  (Unviginticentillion)
    "DVgDCe",  -- 10^366  (Duoviginticentillion)
    "TVgDCe",  -- 10^369  (Treviginticentillion)
    "QaVgDCe", -- 10^372  (Quattuorviginticentillion)
    "QiVgDCe", -- 10^375  (Quinviginticentillion)
    "SxVgDCe", -- 10^378  (Sexviginticentillion)
    "SpVgDCe", -- 10^381  (Septenviginticentillion)
    "OcVgDCe", -- 10^384  (Octoviginticentillion)
    "NoVgDCe", -- 10^387  (Novemviginticentillion),

    -- Triginticentillion group (10^393 to 10^420):
    "TgDCe",    -- 10^393  (Triginticentillion)
    "UTgDCe",   -- 10^396  (Untriginticentillion)
    "DTgDCe",   -- 10^399  (Duotriginticentillion)
    "TTgDCe",   -- 10^402  (Tretriginticentillion)
    "QaTgDCe",  -- 10^405  (Quattuortriginticentillion)
    "QiTgDCe",  -- 10^408  (Quintriginticentillion)
    "SxTgDCe",  -- 10^411  (Sextriginticentillion)
    "SpTgDCe",  -- 10^414  (Septentriginticentillion)
    "OcTgDCe",  -- 10^417  (Octotriginticentillion)
    "NoTgDCe",  -- 10^420  (Novemtriginticentillion),

    -- Quadragintacentillion group (10^423 to 10^450):
    "qgDCe",   -- 10^423  (Quadragintacentillion)
    "UqgDCe",  -- 10^426  (Unquadragintacentillion)
    "DqgDCe",  -- 10^429  (Duoquadragintacentillion)
    "TqgDCe",  -- 10^432  (Trequadragintacentillion)
    "QaqgDCe", -- 10^435  (Quattuorquadragintacentillion)
    "QiqgDCe", -- 10^438  (Quinquadragintacentillion)
    "SxqgDCe", -- 10^441  (Sexquadragintacentillion)
    "SpqgDCe", -- 10^444  (Septenquadragintacentillion)
    "OcqgDCe", -- 10^447  (Octoquadragintacentillion)
    "NoqgDCe", -- 10^450  (Novemquadragintacentillion),

    -- Quinquagintacentillion group (10^453 to 10^480):
    "QgDCe",   -- 10^453  (Quinquagintacentillion)
    "UQgDCe",  -- 10^456  (Unquinquagintacentillion)
    "DQgDCe",  -- 10^459  (Duoquinquagintacentillion)
    "TQgDCe",  -- 10^462  (Trequinquagintacentillion)
    "QaQgDCe", -- 10^465  (Quattuorquinquagintacentillion)
    "QiQgDCe", -- 10^468  (Quinquinquagintacentillion)
    "SxQgDCe", -- 10^471  (Sexquinquagintacentillion)
    "SpQgDCe", -- 10^474  (Septenquinquagintacentillion)
    "OcQgDCe", -- 10^477  (Octoquinquagintacentillion)
    "NoQgDCe", -- 10^480  (Novemquinquagintacentillion),

    -- Sexagintacentillion group (10^483 to 10^510):
    "sgDCe",   -- 10^483  (Sexagintacentillion)
    "UsgDCe",  -- 10^486  (Unsexagintacentillion)
    "DsgDCe",  -- 10^489  (Duosexagintacentillion)
    "TsgDCe",  -- 10^492  (Tresexagintacentillion)
    "QasgDCe", -- 10^495  (Quattuorsexagintacentillion)
    "QisgDCe", -- 10^498  (Quinsexagintacentillion)
    "SxsgDCe", -- 10^501  (Sexsexagintacentillion)
    "SpsgDCe", -- 10^504  (Septensexagintacentillion)
    "OcsgDCe", -- 10^507  (Octosexagintacentillion)
    "NosgDCe", -- 10^510  (Novemsexagintacentillion),

    -- Septuacentillion group (10^513 to 10^540):
    "SgDCe",   -- 10^513  (Septuacentillion)
    "USgDCe",  -- 10^516  (Unseptuacentillion)
    "DSgDCe",  -- 10^519  (Duoseptuacentillion)
    "TSgDCe",  -- 10^522  (Treseptuacentillion)
    "QaSgDCe", -- 10^525  (Quattuorseptuacentillion)
    "QiSgDCe", -- 10^528  (Quinseptuacentillion)
    "SxSgDCe", -- 10^531  (Sexseptuacentillion)
    "SpSgDCe", -- 10^534  (Septenseptuacentillion)
    "OcSgDCe", -- 10^537  (Octoseptuacentillion)
    "NoSgDCe", -- 10^540  (Novemseptuacentillion),

    -- Octogintacentillion group (10^543 to 10^570):
    "OgDCe",   -- 10^543  (Octogintacentillion)
    "UOgDCe",  -- 10^546  (Unoctogintacentillion)
    "DOgDCe",  -- 10^549  (Duooctogintacentillion)
    "TOgDCe",  -- 10^552  (Treoctogintacentillion)
    "QaOgDCe", -- 10^555  (Quattuoroctogintacentillion)
    "QiOgDCe", -- 10^558  (Quinoctogintacentillion)
    "SxOgDCe", -- 10^561  (Sexoctogintacentillion)
    "SpOgDCe", -- 10^564  (Septenoctogintacentillion)
    "OcOgDCe", -- 10^567  (Octooctogintacentillion)
    "NoOgDCe", -- 10^570  (Novemoctogintacentillion),

    -- Nonagintacentillion group (10^573 to 10^600):
    "NgDCe",   -- 10^573  (Nonagintacentillion)
    "UNgDCe",  -- 10^576  (Unnonagintacentillion)
    "DNgDCe",  -- 10^579  (Duononagintacentillion)
    "TNgDCe",  -- 10^582  (Trenonagintacentillion)
    "QaNgDCe", -- 10^585  (Quattuornonagintacentillion)
    "QiNgDCe", -- 10^588  (Quinnonagintacentillion)
    "SxNgDCe", -- 10^591  (Sexnonagintacentillion)
    "SpNgDCe", -- 10^594  (Septennonagintacentillion)
    "OcNgDCe", -- 10^597  (Octononagintacentillion)
    "NoNgDCe", -- 10^600  (Novemnonagintacentillion),

    -- Trecentillion family (10^633 to 10^660)
    "TCe",     -- 10^633  (Trecentillion)
    "UTCe",    -- 10^636  (Untrecentillion)
    "DTCe",    -- 10^639  (Duotrecentillion)
    "TTCe",    -- 10^642  (Tretrecentillion)
    "QaTCe",   -- 10^645  (Quattuortrecentillion)
    "QiTCe",   -- 10^648  (Quintrecentillion)
    "SxTCe",   -- 10^651  (Sextrecentillion)
    "SpTCe",   -- 10^654  (Septentrecentillion)
    "OcTCe",   -- 10^657  (Octotrecentillion)
    "NoTCe",   -- 10^660  (Novemtrecentillion),

    -- Vggintitrecentillion group (10^663 to 10^690)
    "VgTCe",   -- 10^663  (Vggintitrecentillion)
    "UVgTCe",  -- 10^666  (Unvigintitrecentillion)
    "DVgTCe",  -- 10^669  (Duovigintitrecentillion)
    "TVgTCe",  -- 10^672  (Trevigintitrecentillion)
    "QaVgTCe", -- 10^675  (Quattuorvigintitrecentillion)
    "QiVgTCe", -- 10^678  (Quinvigintitrecentillion)
    "SxVgTCe", -- 10^681  (Sexvigintitrecentillion)
    "SpVgTCe", -- 10^684  (Septenvigintitrecentillion)
    "OcVgTCe", -- 10^687  (Octovigintitrecentillion)
    "NoVgTCe", -- 10^690  (Novemvigintitrecentillion),

    -- Trigintitrecentillion group (10^693 to 10^720)
    "TgTCe",    -- 10^693  (Trigintitrecentillion)
    "UTgTCe",   -- 10^696  (Untrigintitrecentillion)
    "DTgTCe",   -- 10^699  (Duotrigintitrecentillion)
    "TTgTCe",   -- 10^702  (Tretrigintitrecentillion)
    "QaTgTCe",  -- 10^705  (Quattuortrigintitrecentillion)
    "QiTgTCe",  -- 10^708  (Quintrigintitrecentillion)
    "SxTgTCe",  -- 10^711  (Sextrigintitrecentillion)
    "SpTgTCe",  -- 10^714  (Septentrigintitrecentillion)
    "OcTgTCe",  -- 10^717  (Octotrigintitrecentillion)
    "NoTgTCe",  -- 10^720  (Novemtrigintitrecentillion),

    -- Quadragintitrecentillion group (10^723 to 10^750)
    "qgTCe",   -- 10^723  (Quadragintitrecentillion)
    "UqgTCe",  -- 10^726  (Unquadragintitrecentillion)
    "DqgTCe",  -- 10^729  (Duoquadragintitrecentillion)
    "TqgTCe",  -- 10^732  (Trequadragintitrecentillion)
    "QaqgTCe", -- 10^735  (Quattuorquadragintitrecentillion)
    "QiqgTCe", -- 10^738  (Quinquadragintitrecentillion)
    "SxqgTCe", -- 10^741  (Sexquadragintitrecentillion)
    "SpqgTCe", -- 10^744  (Septenquadragintitrecentillion)
    "OcqgTCe", -- 10^747  (Octoquadragintitrecentillion)
    "NoqgTCe", -- 10^750  (Novemquadragintitrecentillion),

    -- Quinquagintitrecentillion group (10^753 to 10^780)
    "QgTCe",   -- 10^753  (Quinquagintitrecentillion)
    "UQgTCe",  -- 10^756  (Unquinquagintitrecentillion)
    "DQgTCe",  -- 10^759  (Duoquinquagintitrecentillion)
    "TQgTCe",  -- 10^762  (Trequinquagintitrecentillion)
    "QaQgTCe", -- 10^765  (Quattuorquinquagintitrecentillion)
    "QiQgTCe", -- 10^768  (Quinquinquagintitrecentillion)
    "SxQgTCe", -- 10^771  (Sexquinquagintitrecentillion)
    "SpQgTCe", -- 10^774  (Septenquinquagintitrecentillion)
    "OcQgTCe", -- 10^777  (Octoquinquagintitrecentillion)
    "NoQgTCe", -- 10^780  (Novemquinquagintitrecentillion),

    -- Sexagintitrecentillion group (10^783 to 10^810)
    "sgTCe",   -- 10^783  (Sexagintitrecentillion)
    "UsgTCe",  -- 10^786  (Unsexagintitrecentillion)
    "DsgTCe",  -- 10^789  (Duosexagintitrecentillion)
    "TsgTCe",  -- 10^792  (Tresexagintitrecentillion)
    "QasgTCe", -- 10^795  (Quattuorsexagintitrecentillion)
    "QisgTCe", -- 10^798  (Quinsexagintitrecentillion)
    "SxsgTCe", -- 10^801  (Sexsexagintitrecentillion)
    "SpsgTCe", -- 10^804  (Septensexagintitrecentillion)
    "OcsgTCe", -- 10^807  (Octosexagintitrecentillion)
    "NosgTCe", -- 10^810  (Novemsexagintitrecentillion),

    -- Septuagintitrecentillion group (10^813 to 10^840)
    "SgTCe",    -- 10^813  (Septuagintitrecentillion)
    "USgTCe",   -- 10^816  (Unseptuagintitrecentillion)
    "DSgTCe",   -- 10^819  (Duoseptuagintitrecentillion)
    "TSgTCe",   -- 10^822  (Treseptuagintitrecentillion)
    "QaSgTCe",  -- 10^825  (Quattuorseptuagintitrecentillion)
    "QiSgTCe",  -- 10^828  (Quinseptuagintitrecentillion)
    "SxSgTCe",  -- 10^831  (Sexseptuagintitrecentillion)
    "SpSgTCe",  -- 10^834  (Septenseptuagintitrecentillion)
    "OcSgTCe",  -- 10^837  (Octoseptuagintitrecentillion)
    "NoSgTCe",  -- 10^840  (Novemseptuagintitrecentillion),

    -- Octogintitrecentillion group (10^843 to 10^870)
    "OgTCe",    -- 10^843  (Octogintitrecentillion)
    "UOgTCe",   -- 10^846  (Unoctogintitrecentillion)
    "DOgTCe",   -- 10^849  (Duooctogintitrecentillion)
    "TOgTCe",   -- 10^852  (Treoctogintitrecentillion)
    "QaOgTCe",  -- 10^855  (Quattuoroctogintitrecentillion)
    "QiOgTCe",  -- 10^858  (Quinoctogintitrecentillion)
    "SxOgTCe",  -- 10^861  (Sexoctogintitrecentillion)
    "SpOgTCe",  -- 10^864  (Septenoctogintitrecentillion)
    "OcOgTCe",  -- 10^867  (Octooctogintitrecentillion)
    "NoOgTCe",  -- 10^870  (Novemoctogintitrecentillion),

    -- Nonagintitrecentillion group (10^873 to 10^900)
    "NgTCe",    -- 10^873  (Nonagintitrecentillion)
    "UNgTCe",   -- 10^876  (Unnonagintitrecentillion)
    "DNgTCe",   -- 10^879  (Duononagintitrecentillion)
    "TNgTCe",   -- 10^882  (Trenonagintitrecentillion)
    "QaNgTCe",  -- 10^885  (Quattuornonagintitrecentillion)
    "QiNgTCe",  -- 10^888  (Quinnonagintitrecentillion)
    "SxNgTCe",  -- 10^891  (Sexnonagintitrecentillion)
    "SpNgTCe",  -- 10^894  (Septennonagintitrecentillion)
    "OcNgTCe",  -- 10^897  (Octononagintitrecentillion)
    "NoNgTCe",  -- 10^900  (Novemnonagintitrecentillion),

    -- Quadringentillion family (10^903 to 10^930)
    "QaCe",     -- 10^903  (Quadringentillion)
    "UQaCe",    -- 10^906  (Unquadringentillion)
    "DQaCe",    -- 10^909  (Duoquadringentillion)
    "TQaCe",    -- 10^912  (Trequadringentillion)
    "QaQaCe",   -- 10^915  (Quattuorquadringentillion)
    "QiQaCe",   -- 10^918  (Quinquadringentillion)
    "SxQaCe",   -- 10^921  (Sexquadringentillion)
    "SpQaCe",   -- 10^924  (Septenquadringentillion)
    "OcQaCe",   -- 10^927  (Octoquadringentillion)
    "NoQaCe",   -- 10^930  (Novemquadringentillion),

    -- Vggintiquadringentillion group (10^933 to 10^960)
    "VgQaCe",   -- 10^933  (Vggintiquadringentillion)
    "UVgQaCe",  -- 10^936  (Unvigintiquadringentillion)
    "DVgQaCe",  -- 10^939  (Duovigintiquadringentillion)
    "TVgQaCe",  -- 10^942  (Trevigintiquadringentillion)
    "QaVgQaCe", -- 10^945  (Quattuorvigintiquadringentillion)
    "QiVgQaCe", -- 10^948  (Quinvigintiquadringentillion)
    "SxVgQaCe", -- 10^951  (Sexvigintiquadringentillion)
    "SpVgQaCe", -- 10^954  (Septenvigintiquadringentillion)
    "OcVgQaCe", -- 10^957  (Octovigintiquadringentillion)
    "NoVgQaCe", -- 10^960  (Novemvigintiquadringentillion),

    -- Trigintiquadringentillion group (10^963 to 10^990)
    "TgQaCe",    -- 10^963  (Trigintiquadringentillion)
    "UTgQaCe",   -- 10^966  (Untrigintiquadringentillion)
    "DTgQaCe",   -- 10^969  (Duotrigintiquadringentillion)
    "TTgQaCe",   -- 10^972  (Tretrigintiquadringentillion)
    "QaTgQaCe",  -- 10^975  (Quattuortrigintiquadringentillion)
    "QiTgQaCe",  -- 10^978  (Quintrigintiquadringentillion)
    "SxTgQaCe",  -- 10^981  (Sextrigintiquadringentillion)
    "SpTgQaCe",  -- 10^984  (Septentrigintiquadringentillion)
    "OcTgQaCe",  -- 10^987  (Octotrigintiquadringentillion)
    "NoTgQaCe",  -- 10^990  (Novemtrigintiquadringentillion),

    -- Quadragintiquadringentillion group (10^993 to 10^1020)
    "qgQaCe",   -- 10^993  (Quadragintiquadringentillion)
    "UqgQaCe",  -- 10^996  (Unquadragintiquadringentillion)
    "DqgQaCe",  -- 10^999  (Duoquadragintiquadringentillion)
    "TqgQaCe",  -- 10^1002 (Trequadragintiquadringentillion)
    "QaqgQaCe", -- 10^1005 (Quattuorquadragintiquadringentillion)
    "QiqgQaCe", -- 10^1008 (Quinquadragintiquadringentillion)
    "SxqgQaCe", -- 10^1011 (Sexquadragintiquadringentillion)
    "SpqgQaCe", -- 10^1014 (Septenquadragintiquadringentillion)
    "OcqgQaCe", -- 10^1017 (Octoquadragintiquadringentillion)
    "NoqgQaCe", -- 10^1020 (Novemquadragintiquadringentillion),

    -- Quinquagintiquadringentillion group (10^1023 to 10^1050)
    "QgQaCe",   -- 10^1023 (Quinquagintiquadringentillion)
    "UQgQaCe",  -- 10^1026 (Unquinquagintiquadringentillion)
    "DQgQaCe",  -- 10^1029 (Duoquinquagintiquadringentillion)
    "TQgQaCe",  -- 10^1032 (Trequinquagintiquadringentillion)
    "QaQgQaCe", -- 10^1035 (Quattuorquinquagintiquadringentillion)
    "QiQgQaCe", -- 10^1038 (Quinquinquagintiquadringentillion)
    "SxQgQaCe", -- 10^1041 (Sexquinquagintiquadringentillion)
    "SpQgQaCe", -- 10^1044 (Septenquinquagintiquadringentillion)
    "OcQgQaCe", -- 10^1047 (Octoquinquagintiquadringentillion)
    "NoQgQaCe", -- 10^1050 (Novemquinquagintiquadringentillion),

    -- Sexagintiquadringentillion group (10^1053 to 10^1080)
    "sgQaCe",   -- 10^1053 (Sexagintiquadringentillion)
    "UsgQaCe",  -- 10^1056 (Unsexagintiquadringentillion)
    "DsgQaCe",  -- 10^1059 (Duosexagintiquadringentillion)
    "TsgQaCe",  -- 10^1062 (Tresexagintiquadringentillion)
    "QasgQaCe", -- 10^1065 (Quattuorsexagintiquadringentillion)
    "QisgQaCe", -- 10^1068 (Quinsexagintiquadringentillion)
    "SxsgQaCe", -- 10^1071 (Sexsexagintiquadringentillion)
    "SpsgQaCe", -- 10^1074 (Septensexagintiquadringentillion)
    "OcsgQaCe", -- 10^1077 (Octosexagintiquadringentillion)
    "NosgQaCe", -- 10^1080 (Novemsexagintiquadringentillion),

    -- Septuagintiquadringentillion group (10^1083 to 10^1110)
    "SgQaCe",   -- 10^1083 (Septuagintiquadringentillion)
    "USgQaCe",  -- 10^1086 (Unseptuagintiquadringentillion)
    "DSgQaCe",  -- 10^1089 (Duoseptuagintiquadringentillion)
    "TSgQaCe",  -- 10^1092 (Treseptuagintiquadringentillion)
    "QaSgQaCe", -- 10^1095 (Quattuorseptuagintiquadringentillion)
    "QiSgQaCe", -- 10^1098 (Quinseptuagintiquadringentillion)
    "SxSgQaCe", -- 10^1101 (Sexseptuagintiquadringentillion)
    "SpSgQaCe", -- 10^1104 (Septenseptuagintiquadringentillion)
    "OcSgQaCe", -- 10^1107 (Octoseptuagintiquadringentillion)
    "NoSgQaCe", -- 10^1110 (Novemseptuagintiquadringentillion),

    -- Octogintiquadringentillion group (10^1113 to 10^1140)
    "OgQaCe",   -- 10^1113 (Octogintiquadringentillion)
    "UOgQaCe",  -- 10^1116 (Unoctogintiquadringentillion)
    "DOgQaCe",  -- 10^1119 (Duooctogintiquadringentillion)
    "TOgQaCe",  -- 10^1122 (Treoctogintiquadringentillion)
    "QaOgQaCe", -- 10^1125 (Quattuoroctogintiquadringentillion)
    "QiOgQaCe", -- 10^1128 (Quinoctogintiquadringentillion)
    "SxOgQaCe", -- 10^1131 (Sexoctogintiquadringentillion)
    "SpOgQaCe", -- 10^1134 (Septenoctogintiquadringentillion)
    "OcOgQaCe", -- 10^1137 (Octooctogintiquadringentillion)
    "NoOgQaCe", -- 10^1140 (Novemoctogintiquadringentillion),

    -- Nonagintiquadringentillion group (10^1143 to 10^1170)
    "NgQaCe",   -- 10^1143 (Nonagintiquadringentillion)
    "UNgQaCe",  -- 10^1146 (Unnonagintiquadringentillion)
    "DNgQaCe",  -- 10^1149 (Duononagintiquadringentillion)
    "TNgQaCe",  -- 10^1152 (Trenonagintiquadringentillion)
    "QaNgQaCe", -- 10^1155 (Quattuornonagintiquadringentillion)
    "QiNgQaCe", -- 10^1158 (Quinnonagintiquadringentillion)
    "SxNgQaCe", -- 10^1161 (Sexnonagintiquadringentillion)
    "SpNgQaCe", -- 10^1164 (Septennonagintiquadringentillion)
    "OcNgQaCe", -- 10^1167 (Octononagintiquadringentillion)
    "NoNgQaCe", -- 10^1170 (Novemnonagintiquadringentillion),

    -- Quingentillion family (10^1203 to 10^1230) --
    "QiCe",     -- 10^1203 (Quingentillion)
    "UQiCe",    -- 10^1206 (Unquingentillion)
    "DQiCe",    -- 10^1209 (Duoquingentillion)
    "TQiCe",    -- 10^1212 (Trequingentillion)
    "QaQiCe",   -- 10^1215 (Quattuorquingentillion)
    "QiQiCe",   -- 10^1218 (Quinquingentillion)
    "SxQiCe",   -- 10^1221 (Sexquingentillion)
    "SpQiCe",   -- 10^1224 (Septenquingentillion)
    "OcQiCe",   -- 10^1227 (Octoquingentillion)
    "NoQiCe",   -- 10^1230 (Novemquingentillion),

    -- Vggintiquingentillion group (10^1233 to 10^1260)
    "VgQiCe",   -- 10^1233 (Vggintiquingentillion)
    "UVgQiCe",  -- 10^1236 (Unvigintiquingentillion)
    "DVgQiCe",  -- 10^1239 (Duovigintiquingentillion)
    "TVgQiCe",  -- 10^1242 (Trevigintiquingentillion)
    "QaVgQiCe", -- 10^1245 (Quattuorvigintiquingentillion)
    "QiVgQiCe", -- 10^1248 (Quinvigintiquingentillion)
    "SxVgQiCe", -- 10^1251 (Sexvigintiquingentillion)
    "SpVgQiCe", -- 10^1254 (Septenvigintiquingentillion)
    "OcVgQiCe", -- 10^1257 (Octovigintiquingentillion)
    "NoVgQiCe", -- 10^1260 (Novemvigintiquingentillion),

    -- Trigintiquingentillion Group (10^1263-10^1290)
    "TgQiCe",    -- 10^1263 (Trigintiquingentillion)
    "UTgQiCe",   -- 10^1266 (Untrigintiquingentillion)
    "DTgQiCe",   -- 10^1269 (Duotrigintiquingentillion)
    "TTgQiCe",   -- 10^1272 (Tretrigintiquingentillion)
    "QaTgQiCe",  -- 10^1275 (Quattuortrigintiquingentillion)
    "QiTgQiCe",  -- 10^1278 (Quintrigintiquingentillion)
    "SxTgQiCe",  -- 10^1281 (Sextrigintiquingentillion)
    "SpTgQiCe",  -- 10^1284 (Septentrigintiquingentillion)
    "OcTgQiCe",  -- 10^1287 (Octotrigintiquingentillion)
    "NoTgQiCe",  -- 10^1290 (Novemtrigintiquingentillion),

    -- Quadragintiquingentillion Group (10^1293-10^1320)
    "qgQiCe",   -- 10^1293 (Quadragintiquingentillion)
    "UqgQiCe",  -- 10^1296 (Unquadragintiquingentillion)
    "DqgQiCe",  -- 10^1299 (Duoquadragintiquingentillion)
    "TqgQiCe",  -- 10^1302 (Trequadragintiquingentillion)
    "QaqgQiCe", -- 10^1305 (Quattuorquadragintiquingentillion)
    "QiqgQiCe", -- 10^1308 (Quinquadragintiquingentillion)
    "SxqgQiCe", -- 10^1311 (Sexquadragintiquingentillion)
    "SpqgQiCe", -- 10^1314 (Septenquadragintiquingentillion)
    "OcqgQiCe", -- 10^1317 (Octoquadragintiquingentillion)
    "NoqgQiCe", -- 10^1320 (Novemquadragintiquingentillion),

    -- Quinquagintiquingentillion Group (10^1323-10^1350)
    "QgQiCe",   -- 10^1323 (Quinquagintiquingentillion)
    "UQgQiCe",  -- 10^1326 (Unquinquagintiquingentillion)
    "DQgQiCe",  -- 10^1329 (Duoquinquagintiquingentillion)
    "TQgQiCe",  -- 10^1332 (Trequinquagintiquingentillion)
    "QaQgQiCe", -- 10^1335 (Quattuorquinquagintiquingentillion)
    "QiQgQiCe", -- 10^1338 (Quinquinquagintiquingentillion)
    "SxQgQiCe", -- 10^1341 (Sexquinquagintiquingentillion)
    "SpQgQiCe", -- 10^1344 (Septenquinquagintiquingentillion)
    "OcQgQiCe", -- 10^1347 (Octoquinquagintiquingentillion)
    "NoQgQiCe", -- 10^1350 (Novemquinquagintiquingentillion),

    -- Sexagintiquingentillion Group (10^1353-10^1380)
    "sgQiCe",   -- 10^1353 (Sexagintiquingentillion)
    "UsgQiCe",  -- 10^1356 (Unsexagintiquingentillion)
    "DsgQiCe",  -- 10^1359 (Duosexagintiquingentillion)
    "TsgQiCe",  -- 10^1362 (Tresexagintiquingentillion)
    "QasgQiCe", -- 10^1365 (Quattuorsexagintiquingentillion)
    "QisgQiCe", -- 10^1368 (Quinsexagintiquingentillion)
    "SxsgQiCe", -- 10^1371 (Sexsexagintiquingentillion)
    "SpsgQiCe", -- 10^1374 (Septensexagintiquingentillion)
    "OcsgQiCe", -- 10^1377 (Octosexagintiquingentillion)
    "NosgQiCe", -- 10^1380 (Novemsexagintiquingentillion),

    -- Septuagintiquingentillion Group (10^1383-10^1410)
    "SgQiCe",   -- 10^1383 (Septuagintiquingentillion)
    "USgQiCe",  -- 10^1386 (Unseptuagintiquingentillion)
    "DSgQiCe",  -- 10^1389 (Duoseptuagintiquingentillion)
    "TSgQiCe",  -- 10^1392 (Treseptuagintiquingentillion)
    "QaSgQiCe", -- 10^1395 (Quattuorseptuagintiquingentillion)
    "QiSgQiCe", -- 10^1398 (Quinseptuagintiquingentillion)
    "SxSgQiCe", -- 10^1401 (Sexseptuagintiquingentillion)
    "SpSgQiCe", -- 10^1404 (Septenseptuagintiquingentillion)
    "OcSgQiCe", -- 10^1407 (Octoseptuagintiquingentillion)
    "NoSgQiCe", -- 10^1410 (Novemseptuagintiquingentillion),

    -- Octogintiquingentillion Group (10^1413-10^1440)
    "OgQiCe",   -- 10^1413 (Octogintiquingentillion)
    "UOgQiCe",  -- 10^1416 (Unoctogintiquingentillion)
    "DOgQiCe",  -- 10^1419 (Duooctogintiquingentillion)
    "TOgQiCe",  -- 10^1422 (Treoctogintiquingentillion)
    "QaOgQiCe", -- 10^1425 (Quattuoroctogintiquingentillion)
    "QiOgQiCe", -- 10^1428 (Quinoctogintiquingentillion)
    "SxOgQiCe", -- 10^1431 (Sexoctogintiquingentillion)
    "SpOgQiCe", -- 10^1434 (Septenoctogintiquingentillion)
    "OcOgQiCe", -- 10^1437 (Octooctogintiquingentillion)
    "NoOgQiCe", -- 10^1440 (Novemoctogintiquingentillion),

    -- Nonagintiquingentillion Group (10^1443-10^1470)
    "NgQiCe",   -- 10^1443 (Nonagintiquingentillion)
    "UNgQiCe",  -- 10^1446 (Unnonagintiquingentillion)
    "DNgQiCe",  -- 10^1449 (Duononagintiquingentillion)
    "TNgQiCe",  -- 10^1452 (Trenonagintiquingentillion)
    "QaNgQiCe", -- 10^1455 (Quattuornonagintiquingentillion)
    "QiNgQiCe", -- 10^1458 (Quinnonagintiquingentillion)
    "SxNgQiCe", -- 10^1461 (Sexnonagintiquingentillion)
    "SpNgQiCe", -- 10^1464 (Septennonagintiquingentillion)
    "OcNgQiCe", -- 10^1467 (Octononagintiquingentillion)
    "NoNgQiCe", -- 10^1470 (Novemnonagintiquingentillion),

    -- ===== Sescentillion Family (10^1803-10^2103) =====
    -- Base Group (10^1803-10^1830)
    "SxCe",     -- 10^1803
    "USxCe",    -- 10^1806
    "DSxCe",    -- 10^1809
    "TSxCe",    -- 10^1812
    "QaSxCe",   -- 10^1815
    "QiSxCe",   -- 10^1818
    "SxSxCe",   -- 10^1821
    "SpSxCe",   -- 10^1824
    "OcSxCe",   -- 10^1827
    "NoSxCe",   -- 10^1830,

    -- Vggintisescentillion (10^1833-10^1860)
    "VgSxCe",   -- 10^1833
    "UVgSxCe",  -- 10^1836
    "DVgSxCe",  -- 10^1839
    "TVgSxCe",  -- 10^1842
    "QaVgSxCe", -- 10^1845
    "QiVgSxCe", -- 10^1848
    "SxVgSxCe", -- 10^1851
    "SpVgSxCe", -- 10^1854
    "OcVgSxCe", -- 10^1857
    "NoVgSxCe", -- 10^1860,

    -- Trigintisescentillion Group (10^1863-10^1890)
    "TgSxCe",    -- 10^1863 (Trigintisescentillion)
    "UTgSxCe",   -- 10^1866 (Untrigintisescentillion)
    "DTgSxCe",   -- 10^1869 (Duotrigintisescentillion)
    "TTgSxCe",   -- 10^1872 (Tretrigintisescentillion)
    "QaTgSxCe",  -- 10^1875 (Quattuortrigintisescentillion)
    "QiTgSxCe",  -- 10^1878 (Quintrigintisescentillion)
    "SxTgSxCe",  -- 10^1881 (Sextrigintisescentillion)
    "SpTgSxCe",  -- 10^1884 (Septentrigintisescentillion)
    "OcTgSxCe",  -- 10^1887 (Octotrigintisescentillion)
    "NoTgSxCe",  -- 10^1890 (Novemtrigintisescentillion),

    -- Quadragintisescentillion Group (10^1893-10^1920)
    "qgSxCe",   -- 10^1893 (Quadragintisescentillion)
    "UqgSxCe",  -- 10^1896 (Unquadragintisescentillion)
    "DqgSxCe",  -- 10^1899 (Duoquadragintisescentillion)
    "TqgSxCe",  -- 10^1902 (Trequadragintisescentillion)
    "QaqgSxCe", -- 10^1905 (Quattuorquadragintisescentillion)
    "QiqgSxCe", -- 10^1908 (Quinquadragintisescentillion)
    "SxqgSxCe", -- 10^1911 (Sexquadragintisescentillion)
    "SpqgSxCe", -- 10^1914 (Septenquadragintisescentillion)
    "OcqgSxCe", -- 10^1917 (Octoquadragintisescentillion)
    "NoqgSxCe", -- 10^1920 (Novemquadragintisescentillion),

    -- Quinquagintisescentillion Group (10^1923-10^1950)
    "QgSxCe",   -- 10^1923 (Quinquagintisescentillion)
    "UQgSxCe",  -- 10^1926 (Unquinquagintisescentillion)
    "DQgSxCe",  -- 10^1929 (Duoquinquagintisescentillion)
    "TQgSxCe",  -- 10^1932 (Trequinquagintisescentillion)
    "QaQgSxCe", -- 10^1935 (Quattuorquinquagintisescentillion)
    "QiQgSxCe", -- 10^1938 (Quinquinquagintisescentillion)
    "SxQgSxCe", -- 10^1941 (Sexquinquagintisescentillion)
    "SpQgSxCe", -- 10^1944 (Septenquinquagintisescentillion)
    "OcQgSxCe", -- 10^1947 (Octoquinquagintisescentillion)
    "NoQgSxCe", -- 10^1950 (Novemquinquagintisescentillion),

    -- Sexagintisescentillion Group (10^1953-10^1980)
    "sgSxCe",   -- 10^1953 (Sexagintisescentillion)
    "UsgSxCe",  -- 10^1956 (Unsexagintisescentillion)
    "DsgSxCe",  -- 10^1959 (Duosexagintisescentillion)
    "TsgSxCe",  -- 10^1962 (Tresexagintisescentillion)
    "QasgSxCe", -- 10^1965 (Quattuorsexagintisescentillion)
    "QisgSxCe", -- 10^1968 (Quinsexagintisescentillion)
    "SxsgSxCe", -- 10^1971 (Sexsexagintisescentillion)
    "SpsgSxCe", -- 10^1974 (Septensexagintisescentillion)
    "OcsgSxCe", -- 10^1977 (Octosexagintisescentillion)
    "NosgSxCe", -- 10^1980 (Novemsexagintisescentillion),

    -- Septuagintisescentillion Group (10^1983-10^2010)
    "SgSxCe",   -- 10^1983 (Septuagintisescentillion)
    "USgSxCe",  -- 10^1986 (Unseptuagintisescentillion)
    "DSgSxCe",  -- 10^1989 (Duoseptuagintisescentillion)
    "TSgSxCe",  -- 10^1992 (Treseptuagintisescentillion)
    "QaSgSxCe", -- 10^1995 (Quattuorseptuagintisescentillion)
    "QiSgSxCe", -- 10^1998 (Quinseptuagintisescentillion)
    "SxSgSxCe", -- 10^2001 (Sexseptuagintisescentillion)
    "SpSgSxCe", -- 10^2004 (Septenseptuagintisescentillion)
    "OcSgSxCe", -- 10^2007 (Octoseptuagintisescentillion)
    "NoSgSxCe", -- 10^2010 (Novemseptuagintisescentillion),

    -- Octogintisescentillion Group (10^2013-10^2040)
    "OgSxCe",   -- 10^2013 (Octogintisescentillion)
    "UOgSxCe",  -- 10^2016 (Unoctogintisescentillion)
    "DOgSxCe",  -- 10^2019 (Duooctogintisescentillion)
    "TOgSxCe",  -- 10^2022 (Treoctogintisescentillion)
    "QaOgSxCe", -- 10^2025 (Quattuoroctogintisescentillion)
    "QiOgSxCe", -- 10^2028 (Quinoctogintisescentillion)
    "SxOgSxCe", -- 10^2031 (Sexoctogintisescentillion)
    "SpOgSxCe", -- 10^2034 (Septenoctogintisescentillion)
    "OcOgSxCe", -- 10^2037 (Octooctogintisescentillion)
    "NoOgSxCe", -- 10^2040 (Novemoctogintisescentillion),

    -- Nonagintisescentillion Group (10^2043-10^2070)
    "NgSxCe",   -- 10^2043 (Nonagintisescentillion)
    "UNgSxCe",  -- 10^2046 (Unnonagintisescentillion)
    "DNgSxCe",  -- 10^2049 (Duononagintisescentillion)
    "TNgSxCe",  -- 10^2052 (Trenonagintisescentillion)
    "QaNgSxCe", -- 10^2055 (Quattuornonagintisescentillion)
    "QiNgSxCe", -- 10^2058 (Quinnonagintisescentillion)
    "SxNgSxCe", -- 10^2061 (Sexnonagintisescentillion)
    "SpNgSxCe", -- 10^2064 (Septennonagintisescentillion)
    "OcNgSxCe", -- 10^2067 (Octononagintisescentillion)
    "NoNgSxCe", -- 10^2070 (Novemnonagintisescentillion),

    -- Base Group (10^2103-10^2130)
    "SpCe",    -- 10^2103 (Septingentillion)
    "USpCe",   -- 10^2106 (Unseptingentillion)
    "DSpCe",   -- 10^2109 (Duoseptingentillion)
    "TSpCe",   -- 10^2112 (Treseptingentillion)
    "QaSpCe",  -- 10^2115 (Quattuorseptingentillion)
    "QiSpCe",  -- 10^2118 (Quinseptingentillion)
    "SxSpCe",  -- 10^2121 (Sexseptingentillion)
    "SpSpCe",  -- 10^2124 (Septenseptingentillion)
    "OcSpCe",  -- 10^2127 (Octoseptingentillion)
    "NoSpCe",  -- 10^2130 (Novemseptingentillion),

    -- Vggintiseptingentillion Group (10^2133-10^2160)
    "VgSpCe",  -- 10^2133 (Vggintiseptingentillion)
    "UVgSpCe", -- 10^2136 (Unvigintiseptingentillion)
    "DVgSpCe", -- 10^2139 (Duovigintiseptingentillion)
    "TVgSpCe", -- 10^2142 (Trevigintiseptingentillion)
    "QaVgSpCe",-- 10^2145 (Quattuorvigintiseptingentillion)
    "QiVgSpCe",-- 10^2148 (Quinvigintiseptingentillion)
    "SxVgSpCe",-- 10^2151 (Sexvigintiseptingentillion)
    "SpVgSpCe",-- 10^2154 (Septenvigintiseptingentillion)
    "OcVgSpCe",-- 10^2157 (Octovigintiseptingentillion)
    "NoVgSpCe",-- 10^2160 (Novemvigintiseptingentillion),

    -- Trigintiseptingentillion Group (10^2163-10^2190)
    "TgSpCe",    -- 10^2163
    "UTgSpCe",   -- 10^2166
    "DTgSpCe",   -- 10^2169
    "TTgSpCe",   -- 10^2172
    "QaTgSpCe",  -- 10^2175
    "QiTgSpCe",  -- 10^2178
    "SxTgSpCe",  -- 10^2181
    "SpTgSpCe",  -- 10^2184
    "OcTgSpCe",  -- 10^2187
    "NoTgSpCe",  -- 10^2190,

    -- Quadragintiseptingentillion (10^2193-10^2220)
    "qgSpCe",   -- 10^2193
    "UqgSpCe",  -- 10^2196
    "DqgSpCe",  -- 10^2199
    "TqgSpCe",  -- 10^2202
    "QaqgSpCe", -- 10^2205
    "QiqgSpCe", -- 10^2208
    "SxqgSpCe", -- 10^2211
    "SpqgSpCe", -- 10^2214
    "OcqgSpCe", -- 10^2217
    "NoqgSpCe", -- 10^2220,

    -- Quinquagintiseptingentillion (10^2223-10^2250)
    "QgSpCe",   -- 10^2223
    "UQgSpCe",  -- 10^2226
    "DQgSpCe",  -- 10^2229
    "TQgSpCe",  -- 10^2232
    "QaQgSpCe", -- 10^2235
    "QiQgSpCe", -- 10^2238
    "SxQgSpCe", -- 10^2241
    "SpQgSpCe", -- 10^2244
    "OcQgSpCe", -- 10^2247
    "NoQgSpCe", -- 10^2250,

    -- Sexagintiseptingentillion (10^2253-10^2280)
    "sgSpCe",   -- 10^2253
    "UsgSpCe",  -- 10^2256
    "DsgSpCe",  -- 10^2259
    "TsgSpCe",  -- 10^2262
    "QasgSpCe", -- 10^2265
    "QisgSpCe", -- 10^2268
    "SxsgSpCe", -- 10^2271
    "SpsgSpCe", -- 10^2274
    "OcsgSpCe", -- 10^2277
    "NosgSpCe", -- 10^2280,

    -- Septuagintiseptingentillion (10^2283-10^2310)
    "SgSpCe",   -- 10^2283
    "USgSpCe",  -- 10^2286
    "DSgSpCe",  -- 10^2289
    "TSgSpCe",  -- 10^2292
    "QaSgSpCe", -- 10^2295
    "QiSgSpCe", -- 10^2298
    "SxSgSpCe", -- 10^2301
    "SpSgSpCe", -- 10^2304
    "OcSgSpCe", -- 10^2307
    "NoSgSpCe", -- 10^2310,

    -- Octogintiseptingentillion (10^2313-10^2340)
    "OgSpCe",   -- 10^2313
    "UOgSpCe",  -- 10^2316
    "DOgSpCe",  -- 10^2319
    "TOgSpCe",  -- 10^2322
    "QaOgSpCe", -- 10^2325
    "QiOgSpCe", -- 10^2328
    "SxOgSpCe", -- 10^2331
    "SpOgSpCe", -- 10^2334
    "OcOgSpCe", -- 10^2337
    "NoOgSpCe", -- 10^2340,

    -- Nonagintiseptingentillion (10^2343-10^2370)
    "NgSpCe",   -- 10^2343
    "UNgSpCe",  -- 10^2346
    "DNgSpCe",  -- 10^2349
    "TNgSpCe",  -- 10^2352
    "QaNgSpCe", -- 10^2355
    "QiNgSpCe", -- 10^2358
    "SxNgSpCe", -- 10^2361
    "SpNgSpCe", -- 10^2364
    "OcNgSpCe", -- 10^2367
    "NoNgSpCe", -- 10^2370,

    -- Octingentillion Group (10^2403-10^2430)
    "OcCe",   -- 10^2403
    "UOcCe",  -- 10^2406
    "DOcCe",  -- 10^2409
    "TOcCe",  -- 10^2412
    "QaOcCe", -- 10^2415
    "QiOcCe", -- 10^2418
    "SxOcCe", -- 10^2421
    "SpOcCe", -- 10^2424
    "OcOcCe", -- 10^2427
    "NoOcCe", -- 10^2430,

    -- Vggintioctingentillion (10^2433-10^2460)
    "VgOcCe", -- 10^2433
    "UVgOcCe",-- 10^2436
    "DVgOcCe",-- 10^2439
    "TVgOcCe",-- 10^2442
    "QaVgOcCe",--10^2445
    "QiVgOcCe",--10^2448
    "SxVgOcCe",--10^2451
    "SpVgOcCe",--10^2454
    "OcVgOcCe",--10^2457
    "NoVgOcCe",--10^2460,

    -- Trigintioctingentillion Group (10^2463-10^2490)
    "TgOcCe",    -- 10^2463 (Trigintioctingentillion)
    "UTgOcCe",   -- 10^2466 (Untrigintioctingentillion)
    "DTgOcCe",   -- 10^2469 (Duotrigintioctingentillion)
    "TTgOcCe",   -- 10^2472 (Tretrigintioctingentillion)
    "QaTgOcCe",  -- 10^2475 (Quattuortrigintioctingentillion)
    "QiTgOcCe",  -- 10^2478 (Quintrigintioctingentillion)
    "SxTgOcCe",  -- 10^2481 (Sextrigintioctingentillion)
    "SpTgOcCe",  -- 10^2484 (Septentrigintioctingentillion)
    "OcTgOcCe",  -- 10^2487 (Octotrigintioctingentillion)
    "NoTgOcCe",  -- 10^2490 (Novemtrigintioctingentillion),

    -- Quadragintioctingentillion Group (10^2493-10^2520)
    "qgOcCe",   -- 10^2493 (Quadragintioctingentillion)
    "UqgOcCe",  -- 10^2496 (Unquadragintioctingentillion)
    "DqgOcCe",  -- 10^2499 (Duoquadragintioctingentillion)
    "TqgOcCe",  -- 10^2502 (Trequadragintioctingentillion)
    "QaqgOcCe", -- 10^2505 (Quattuorquadragintioctingentillion)
    "QiqgOcCe", -- 10^2508 (Quinquadragintioctingentillion)
    "SxqgOcCe", -- 10^2511 (Sexquadragintioctingentillion)
    "SpqgOcCe", -- 10^2514 (Septenquadragintioctingentillion)
    "OcqgOcCe", -- 10^2517 (Octoquadragintioctingentillion)
    "NoqgOcCe", -- 10^2520 (Novemquadragintioctingentillion),

    -- Quinquagintioctingentillion Group (10^2523-10^2550)
    "QgOcCe",   -- 10^2523 (Quinquagintioctingentillion)
    "UQgOcCe",  -- 10^2526 (Unquinquagintioctingentillion)
    "DQgOcCe",  -- 10^2529 (Duoquinquagintioctingentillion)
    "TQgOcCe",  -- 10^2532 (Trequinquagintioctingentillion)
    "QaQgOcCe", -- 10^2535 (Quattuorquinquagintioctingentillion)
    "QiQgOcCe", -- 10^2538 (Quinquinquagintioctingentillion)
    "SxQgOcCe", -- 10^2541 (Sexquinquagintioctingentillion)
    "SpQgOcCe", -- 10^2544 (Septenquinquagintioctingentillion)
    "OcQgOcCe", -- 10^2547 (Octoquinquagintioctingentillion)
    "NoQgOcCe", -- 10^2550 (Novemquinquagintioctingentillion),

    -- Sexagintioctingentillion Group (10^2553-10^2580)
    "sgOcCe",   -- 10^2553 (Sexagintioctingentillion)
    "UsgOcCe",  -- 10^2556 (Unsexagintioctingentillion)
    "DsgOcCe",  -- 10^2559 (Duosexagintioctingentillion)
    "TsgOcCe",  -- 10^2562 (Tresexagintioctingentillion)
    "QasgOcCe", -- 10^2565 (Quattuorsexagintioctingentillion)
    "QisgOcCe", -- 10^2568 (Quinsexagintioctingentillion)
    "SxsgOcCe", -- 10^2571 (Sexsexagintioctingentillion)
    "SpsgOcCe", -- 10^2574 (Septensexagintioctingentillion)
    "OcsgOcCe", -- 10^2577 (Octosexagintioctingentillion)
    "NosgOcCe", -- 10^2580 (Novemsexagintioctingentillion),

    -- Septuagintioctingentillion Group (10^2583-10^2610)
    "SgOcCe",   -- 10^2583 (Septuagintioctingentillion)
    "USgOcCe",  -- 10^2586 (Unseptuagintioctingentillion)
    "DSgOcCe",  -- 10^2589 (Duoseptuagintioctingentillion)
    "TSgOcCe",  -- 10^2592 (Treseptuagintioctingentillion)
    "QaSgOcCe", -- 10^2595 (Quattuorseptuagintioctingentillion)
    "QiSgOcCe", -- 10^2598 (Quinseptuagintioctingentillion)
    "SxSgOcCe", -- 10^2601 (Sexseptuagintioctingentillion)
    "SpSgOcCe", -- 10^2604 (Septenseptuagintioctingentillion)
    "OcSgOcCe", -- 10^2607 (Octoseptuagintioctingentillion)
    "NoSgOcCe", -- 10^2610 (Novemseptuagintioctingentillion),

    -- Octogintioctingentillion Group (10^2613-10^2640)
    "OgOcCe",   -- 10^2613 (Octogintioctingentillion)
    "UOgOcCe",  -- 10^2616 (Unoctogintioctingentillion)
    "DOgOcCe",  -- 10^2619 (Duooctogintioctingentillion)
    "TOgOcCe",  -- 10^2622 (Treoctogintioctingentillion)
    "QaOgOcCe", -- 10^2625 (Quattuoroctogintioctingentillion)
    "QiOgOcCe", -- 10^2628 (Quinoctogintioctingentillion)
    "SxOgOcCe", -- 10^2631 (Sexoctogintioctingentillion)
    "SpOgOcCe", -- 10^2634 (Septenoctogintioctingentillion)
    "OcOgOcCe", -- 10^2637 (Octooctogintioctingentillion)
    "NoOgOcCe", -- 10^2640 (Novemoctogintioctingentillion),

    -- Nonagintioctingentillion Group (10^2643-10^2670)
    "NgOcCe",   -- 10^2643 (Nonagintioctingentillion)
    "UNgOcCe",  -- 10^2646 (Unnonagintioctingentillion)
    "DNgOcCe",  -- 10^2649 (Duononagintioctingentillion)
    "TNgOcCe",  -- 10^2652 (Trenonagintioctingentillion)
    "QaNgOcCe", -- 10^2655 (Quattuornonagintioctingentillion)
    "QiNgOcCe", -- 10^2658 (Quinnonagintioctingentillion)
    "SxNgOcCe", -- 10^2661 (Sexnonagintioctingentillion)
    "SpNgOcCe", -- 10^2664 (Septennonagintioctingentillion)
    "OcNgOcCe", -- 10^2667 (Octononagintioctingentillion)
    "NoNgOcCe", -- 10^2670 (Novemnonagintioctingentillion),
    
    -- Nongentillion Group (10^2703-10^2730)
    "NoCe",     -- 10^2703 (Nongentillion)
    "UNoCe",    -- 10^2706 (Unnongentillion)
    "DNoCe",    -- 10^2709 (Duonongentillion)
    "TNoCe",    -- 10^2712 (Trenongentillion)
    "QaNoCe",   -- 10^2715 (Quattuornongentillion)
    "QiNoCe",   -- 10^2718 (Quinnongentillion)
    "SxNoCe",   -- 10^2721 (Sexnongentillion)
    "SpNoCe",   -- 10^2724 (Septennongentillion)
    "OcNoCe",   -- 10^2727 (Octonongentillion)
    "NoNoCe",   -- 10^2730 (Novemnongentillion),

    -- Vggintinongentillion Group (10^2733-10^2760)
    "VgNoCe",   -- 10^2733 (Vggintinongentillion)
    "UVgNoCe",  -- 10^2736 (Unvigintinongentillion)
    "DVgNoCe",  -- 10^2739 (Duovigintinongentillion)
    "TVgNoCe",  -- 10^2742 (Trevigintinongentillion)
    "QaVgNoCe", -- 10^2745 (Quattuorvigintinongentillion)
    "QiVgNoCe", -- 10^2748 (Quinvigintinongentillion)
    "SxVgNoCe", -- 10^2751 (Sexvigintinongentillion)
    "SpVgNoCe", -- 10^2754 (Septenvigintinongentillion)
    "OcVgNoCe", -- 10^2757 (Octovigintinongentillion)
    "NoVgNoCe", -- 10^2760 (Novemvigintinongentillion),

    -- Trigintinongentillion Group (10^2763-10^2790)
    "TgNoCe",    -- 10^2763 (Trigintinongentillion)
    "UTgNoCe",   -- 10^2766 (Untrigintinongentillion)
    "DTgNoCe",   -- 10^2769 (Duotrigintinongentillion)
    "TTgNoCe",   -- 10^2772 (Tretrigintinongentillion)
    "QaTgNoCe",  -- 10^2775 (Quattuortrigintinongentillion)
    "QiTgNoCe",  -- 10^2778 (Quintrigintinongentillion)
    "SxTgNoCe",  -- 10^2781 (Sextrigintinongentillion)
    "SpTgNoCe",  -- 10^2784 (Septentrigintinongentillion)
    "OcTgNoCe",  -- 10^2787 (Octotrigintinongentillion)
    "NoTgNoCe",  -- 10^2790 (Novemtrigintinongentillion),

    -- Quadragintinongentillion Group (10^2793-10^2820)
    "qgNoCe",   -- 10^2793 (Quadragintinongentillion)
    "UqgNoCe",  -- 10^2796 (Unquadragintinongentillion)
    "DqgNoCe",  -- 10^2799 (Duoquadragintinongentillion)
    "TqgNoCe",  -- 10^2802 (Trequadragintinongentillion)
    "QaqgNoCe", -- 10^2805 (Quattuorquadragintinongentillion)
    "QiqgNoCe", -- 10^2808 (Quinquadragintinongentillion)
    "SxqgNoCe", -- 10^2811 (Sexquadragintinongentillion)
    "SpqgNoCe", -- 10^2814 (Septenquadragintinongentillion)
    "OcqgNoCe", -- 10^2817 (Octoquadragintinongentillion)
    "NoqgNoCe", -- 10^2820 (Novemquadragintinongentillion),

    -- Quinquagintinongentillion Group (10^2823-10^2850)
    "QgNoCe",   -- 10^2823 (Quinquagintinongentillion)
    "UQgNoCe",  -- 10^2826 (Unquinquagintinongentillion)
    "DQgNoCe",  -- 10^2829 (Duoquinquagintinongentillion)
    "TQgNoCe",  -- 10^2832 (Trequinquagintinongentillion)
    "QaQgNoCe", -- 10^2835 (Quattuorquinquagintinongentillion)
    "QiQgNoCe", -- 10^2838 (Quinquinquagintinongentillion)
    "SxQgNoCe", -- 10^2841 (Sexquinquagintinongentillion)
    "SpQgNoCe", -- 10^2844 (Septenquinquagintinongentillion)
    "OcQgNoCe", -- 10^2847 (Octoquinquagintinongentillion)
    "NoQgNoCe", -- 10^2850 (Novemquinquagintinongentillion),

    -- Sexagintinongentillion Group (10^2853-10^2880)
    "sgNoCe",   -- 10^2853 (Sexagintinongentillion)
    "UsgNoCe",  -- 10^2856 (Unsexagintinongentillion)
    "DsgNoCe",  -- 10^2859 (Duosexagintinongentillion)
    "TsgNoCe",  -- 10^2862 (Tresexagintinongentillion)
    "QasgNoCe", -- 10^2865 (Quattuorsexagintinongentillion)
    "QisgNoCe", -- 10^2868 (Quinsexagintinongentillion)
    "SxsgNoCe", -- 10^2871 (Sexsexagintinongentillion)
    "SpsgNoCe", -- 10^2874 (Septensexagintinongentillion)
    "OcsgNoCe", -- 10^2877 (Octosexagintinongentillion)
    "NosgNoCe", -- 10^2880 (Novemsexagintinongentillion),

    -- Septuagintinongentillion Group (10^2883-10^2910)
    "SgNoCe",   -- 10^2883 (Septuagintinongentillion)
    "USgNoCe",  -- 10^2886 (Unseptuagintinongentillion)
    "DSgNoCe",  -- 10^2889 (Duoseptuagintinongentillion)
    "TSgNoCe",  -- 10^2892 (Treseptuagintinongentillion)
    "QaSgNoCe", -- 10^2895 (Quattuorseptuagintinongentillion)
    "QiSgNoCe", -- 10^2898 (Quinseptuagintinongentillion)
    "SxSgNoCe", -- 10^2901 (Sexseptuagintinongentillion)
    "SpSgNoCe", -- 10^2904 (Septenseptuagintinongentillion)
    "OcSgNoCe", -- 10^2907 (Octoseptuagintinongentillion)
    "NoSgNoCe", -- 10^2910 (Novemseptuagintinongentillion),

    -- Octogintinongentillion Group (10^2913-10^2940)
    "OgNoCe",   -- 10^2913 (Octogintinongentillion)
    "UOgNoCe",  -- 10^2916 (Unoctogintinongentillion)
    "DOgNoCe",  -- 10^2919 (Duooctogintinongentillion)
    "TOgNoCe",  -- 10^2922 (Treoctogintinongentillion)
    "QaOgNoCe", -- 10^2925 (Quattuoroctogintinongentillion)
    "QiOgNoCe", -- 10^2928 (Quinoctogintinongentillion)
    "SxOgNoCe", -- 10^2931 (Sexoctogintinongentillion)
    "SpOgNoCe", -- 10^2934 (Septenoctogintinongentillion)
    "OcOgNoCe", -- 10^2937 (Octooctogintinongentillion)
    "NoOgNoCe", -- 10^2940 (Novemoctogintinongentillion),

    -- Nonagintinongentillion Group (10^2943-10^2970)
    "NgNoCe",   -- 10^2943 (Nonagintinongentillion)
    "UNgNoCe",  -- 10^2946 (Unnonagintinongentillion)
    "DNgNoCe",  -- 10^2949 (Duononagintinongentillion)
    "TNgNoCe",  -- 10^2952 (Trenonagintinongentillion)
    "QaNgNoCe", -- 10^2955 (Quattuornonagintinongentillion)
    "QiNgNoCe", -- 10^2958 (Quinnonagintinongentillion)
    "SxNgNoCe", -- 10^2961 (Sexnonagintinongentillion)
    "SpNgNoCe", -- 10^2964 (Septennonagintinongentillion)
    "OcNgNoCe", -- 10^2967 (Octononagintinongentillion)
    "NoNgNoCe", -- 10^2970 (Novemnonagintinongentillion),

    -- ===== Millinillion (10^3003) =====
    "Mi",     -- 10^3003 (Millinillion)
}

-- Define a set of available characters used in number encoding/decoding.
local CHARACTERS = {
    "0","1","2","3","4","5","6","7","8","9",
    "a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z",
    "A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z",
    "!","#","$","%","&","'","(",")","","+",".","/",":",";","<","=",">","?","@","[","]","^","_","`","{","}","|","~"
}

-- Precompute frequently used functions and values for performance
local math_floor = math.floor
local string_rep = string.rep
local string_format = string.format
local table_concat = table.concat
local table_create = table.create
local table_insert = table.insert

local base = #CHARACTERS

-- Create a lookup table for notation suffixes. It assumes that a global NOTATION table exists.
-- For each suffix in NOTATION, we map the lowercase version to an exponent multiplier.
local suffixLookup = {}
for i, v in ipairs(NOTATION) do
    suffixLookup[v:lower()] = (i - 1) * 3
end

-- Build a reverse lookup table for numbers based on the CHARACTERS array.
-- For instance, numbers["a"] will return 10.
local numbers = {}
for i, c in ipairs(CHARACTERS) do
    numbers[c] = i - 1
end

--------------------------------------------------------------------------------
-- Function: absBlocks
-- Purpose: Create a new array containing the absolute values of a given array.
-- Example:
--   Input: {-15, 0}
--   Output: {15, 0}
--------------------------------------------------------------------------------
local function absBlocks(blocks)
    local absArr = {}
    for i, v in ipairs(blocks) do
        absArr[i] = math.abs(v)
    end
    return absArr
end

--------------------------------------------------------------------------------
-- Function: compareAbsolute
-- Purpose: Compare two arrays of blocks representing absolute numeric values.
--          The function compares from the most significant block (highest index)
--          to the least and returns:
--           - 1 if arr1 is greater than arr2
--           - -1 if arr1 is less than arr2
--           - 0 if they are equal
-- Example:
--   Input: {15} vs. {20}
--   Explanation: Since 15 < 20, the function returns -1.
--------------------------------------------------------------------------------
local function compareAbsolute(arr1, arr2)
    local maxLength = math.max(#arr1, #arr2)
    for i = maxLength, 1, -1 do
        local a = arr1[i] or 0
        local b = arr2[i] or 0
        if a > b then return 1 end
        if a < b then return -1 end
    end
    return 0
end

--------------------------------------------------------------------------------
-- Function: compareNumbers
-- Purpose: Compare two numbers represented as arrays of blocks, taking into
--          account the sign of each number.
--          - It uses the last block’s sign to determine if the number is negative.
-- Example:
--   Input: {-15} vs. {20}
--   Explanation:
--     The first number has a negative sign (-15) and the second a positive one (20),
--     so the function returns -1 indicating the first is smaller.
--------------------------------------------------------------------------------
local function compareNumbers(num1, num2)
    local sign1 = num1[#num1] < 0 and -1 or 1
    local sign2 = num2[#num2] < 0 and -1 or 1
    if sign1 ~= sign2 then
        -- If signs differ, the negative number is lesser.
        return sign1 < sign2 and -1 or 1
    end
    -- When numbers have the same sign, compare their absolute values.
    return compareAbsolute(absBlocks(num1), absBlocks(num2)) * sign1
end

--------------------------------------------------------------------------------
-- Function: addNumbers
-- Purpose: Add two large numbers represented as arrays of blocks.
-- Explanation:
--     The function loops through each block (of up to 1000) adding them with any carry.
-- Example:
--   Input: {999} plus {2}
--   Process:
--     999 + 2 = 1001 → writes 1 in the current block and carries over 1 to a new block.
--   Output: {1, 1001} (where 1 is the carry in a new higher block)
--------------------------------------------------------------------------------
local function addNumbers(num1, num2)
    local result, carry = {}, 0
    for i = 1, math.max(#num1, #num2) do
        local sum = (num1[i] or 0) + (num2[i] or 0) + carry
        result[i] = sum % 1000  -- each block holds up to 3 digits
        carry = math_floor(sum / 1000)
    end
    if carry > 0 then result[#result+1] = carry end
    return result
end

--------------------------------------------------------------------------------
-- Function: subtractNumbers
-- Purpose: Subtract one large number from another; both numbers are given as block arrays.
-- Explanation:
--     The algorithm works block-by-block, borrowing when the top block is less than the subtrahend.
-- Example:
--   Input: {1000} minus {999}
--   Process:
--     1000 - 999 = 1 (after handling the borrow)
--   Output: {1}
--------------------------------------------------------------------------------
local function subtractNumbers(num1, num2)
    local result, borrow = {}, 0
    for i = 1, math.max(#num1, #num2) do
        local diff = (num1[i] or 0) - (num2[i] or 0) - borrow
        borrow = diff < 0 and 1 or 0
        result[i] = diff < 0 and (diff + 1000) or diff
    end
    while #result > 1 and result[#result] == 0 do
        result[#result] = nil
    end
    return result
end

--------------------------------------------------------------------------------
-- Function: Gigantix.notationToString
-- Purpose: Convert a number in short notation (like "1.5K") into a full number string ("1500").
-- Explanation:
--     The function splits the input into a numerical part and its suffix,
--     then appends the appropriate number of zeros based on the suffix.
-- Example:
--   Input: "1.5K"
--   Process:
--     Finds number "1.5" and suffix "K" (which corresponds to 3 zeros).
--   Output: "1500"
--------------------------------------------------------------------------------
function Gigantix.notationToString(notation, isEncoded)
    if isEncoded then notation = Gigantix.decodeNumber(notation) end
    local number, suffix = notation:match("([%d%.]+)(%a+)")
    return suffix and number .. string_rep("0", suffixLookup[suffix:lower()] or 0) or number
end

--------------------------------------------------------------------------------
-- Function: Gigantix.stringToNumber
-- Purpose: Convert a full number string into an array of numeric blocks.
-- Explanation:
--     The function processes the string from right-to-left, grouping digits in blocks of 3.
-- Example:
--   Input: "15000"
--   Process:
--     It groups "000" (last three) and then "15", resulting in the array {0, 15}.
--   Output: {0, 15}
--------------------------------------------------------------------------------
function Gigantix.stringToNumber(str, isEncoded)
    if isEncoded then str = Gigantix.decodeNumber(str) end
    local blocks, len = {}, #str
    for i = len, 1, -3 do
        table_insert(blocks, tonumber(str:sub(math.max(1, i-2), i)))
    end
    return blocks
end

--------------------------------------------------------------------------------
-- Function: Gigantix.getLong
-- Purpose: Format a block array back into its full number string.
-- Explanation:
--     It concatenates blocks from the highest order to lowest,
--     formatting each block to ensure that lower blocks have exactly 3 digits.
-- Example:
--   Input: {0, 15} 
--   Process:
--     The most significant block "15" is not padded,
--     while the lower block "0" is padded to "000" if needed.
--   Output: "15000"
--------------------------------------------------------------------------------
function Gigantix.getLong(num)
    local parts = {}
    for i = #num, 1, -1 do
        table_insert(parts, (i == #num and "%d" or "%03d"):format(num[i]))
    end
    return table_concat(parts)
end

--------------------------------------------------------------------------------
-- Function: Gigantix.getShort
-- Purpose: Format a block array into a compact, abbreviated notation string.
-- Explanation:
--     It uses a suffix (such as "K" for thousands) based on how many blocks the number has.
--     It also rounds the most significant block combined with a fraction from the next block.
-- Example:
--   Input: {0, 15} (which is "15000")
--   Process:
--     The highest block "15" and the fraction derived from "0" lead to "15K".
--   Output: "15K"
--------------------------------------------------------------------------------
function Gigantix.getShort(num)
    if #num == 0 then return "0" end
    local suffixIndex = #num
    if suffixIndex > #NOTATION then return "Infinity" end
    
    local main = num[#num]
    local sub = #num > 1 and num[#num-1] or 0
    local value = main + sub / 1000
    local rounded = math_floor(value * 10 + 0.5) / 10
    
    return (rounded % 1 == 0 and "%.0f%s" or "%.1f%s")
        :format(rounded, NOTATION[suffixIndex])
end

--------------------------------------------------------------------------------
-- Function: Gigantix.add
-- Purpose: A high-level addition function for two numbers in block array format.
-- Explanation:
--     It compares both numbers (ignoring sign), then adds the blocks accordingly.
-- Example:
--   Input: {15} + {5}
--   Process:
--     Since 15 >= 5, it calls addNumbers to compute the sum.
--   Output: {20}
--------------------------------------------------------------------------------
function Gigantix.add(a, b)
    local cmp = compareAbsolute(a, b)
    return cmp >= 0 and addNumbers(a, b) or addNumbers(b, a)
end

--------------------------------------------------------------------------------
-- Function: Gigantix.difference
-- Purpose: Compute the absolute difference between two numbers represented as block arrays.
-- Explanation:
--     It subtracts the smaller number from the larger one.
-- Example:
--   Input: {15} - {5}
--   Output: {10}
--------------------------------------------------------------------------------
function Gigantix.difference(a, b)
    return compareAbsolute(a, b) >= 0 and subtractNumbers(a, b) or subtractNumbers(b, a)
end

--------------------------------------------------------------------------------
-- Function: Gigantix.isGreaterOrEquals
-- Purpose: Check if the first number is greater than or equal to the second.
-- Example:
--   Input: Compare {15} with {15}
--   Output: true (since they are equal)
--------------------------------------------------------------------------------
function Gigantix.isGreaterOrEquals(a, b)
    return compareNumbers(a, b) >= 0
end

--------------------------------------------------------------------------------
-- Function: Gigantix.isLesserOrEquals
-- Purpose: Check if the first number is less than or equal to the second.
-- Example:
--   Input: Compare {10} with {15}
--   Output: true (because 10 is less than 15)
--------------------------------------------------------------------------------
function Gigantix.isLesserOrEquals(a, b)
    return compareNumbers(a, b) <= 0
end

--------------------------------------------------------------------------------
-- Function: Gigantix.encodeNumber
-- Purpose: Encode a long number (in string format) into a compact, custom base representation.
-- Explanation:
--     It processes the number as a string and converts it into a new base defined by CHARACTERS.
-- Example:
--   Input: "1000000"
--   Process:
--     The function converts the number to a base-N value and maps each digit to a character.
--   Output: A string like "1xFa" (dependent on the mapping in CHARACTERS)
--------------------------------------------------------------------------------
function Gigantix.encodeNumber(value)
    local chars, index = {}, 1
    local num = value:gsub("%D", "")
    while #num > 0 do
        local carry = 0
        -- Process each digit in the current num string.
        for i = 1, #num do
            local digit = carry * 10 + tonumber(num:sub(i, i))
            carry = digit % base
            num = num:sub(1, i-1) .. math_floor(digit / base) .. num:sub(i+1)
        end
        table_insert(chars, 1, CHARACTERS[carry + 1])
        num = num:gsub("^0+", "")
    end
    return (value:sub(1,1) == "-" and "-" or "") .. table_concat(chars)
end

--------------------------------------------------------------------------------
-- Function: Gigantix.decodeNumber
-- Purpose: Decode a compact encoded number string back into a regular number string.
-- Explanation:
--     It converts each character back into its corresponding numeric value and reconstructs the number.
-- Example:
--   Input: "1xFa"
--   Process:
--     The encoded string is processed character by character, converting back into a decimal number.
--   Output: "1000000"
--------------------------------------------------------------------------------
function Gigantix.decodeNumber(value)
    local num, power = {0}, 1
    for c in value:gmatch"." do
        local digit = numbers[c] or 0
        for i = 1, #num do
            num[i] = num[i] + digit * power
            digit = math_floor(num[i] / 10)
            num[i] = num[i] % 10
        end
        while digit > 0 do
            table_insert(num, digit % 10)
            digit = math_floor(digit / 10)
        end
        power = power * base
    end
    return table_concat(num):reverse()
end

return Gigantix