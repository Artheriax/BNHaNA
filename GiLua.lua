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
    "Dc",   -- 10^33   (Decillion)
    "UD",   -- 10^36   (Undecillion)
    "DD",   -- 10^39   (Duodecillion)
    "TD",   -- 10^42   (Tredecillion)
    "QaD",  -- 10^45   (Quattuordecillion)
    "QiD",  -- 10^48   (Quindecillion)
    "SxD",  -- 10^51   (Sexdecillion)
    "SpD",  -- 10^54   (Septendecillion)
    "OcD",  -- 10^57   (Octodecillion)
    "NnD",  -- 10^60   (Novemdecillion)
    "Vi",   -- 10^63   (Vigintillion)
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
    "NnTg",  -- 10^120  (Novemtrigintillion),

    -- Quadragintillion family (10^123 to 10^150):
    "Qag",   -- 10^123  (Quadragintillion)
    "UQag",  -- 10^126  (Unquadragintillion)
    "DQag",  -- 10^129  (Duoquadragintillion)
    "TQag",  -- 10^132  (Trequadragintillion)
    "QaQag", -- 10^135  (Quattuorquadragintillion)
    "QiQag", -- 10^138  (Quinquadragintillion)
    "SxQag", -- 10^141  (Sexquadragintillion)
    "SpQag", -- 10^144  (Septenquadragintillion)
    "OcQag", -- 10^147  (Octoquadragintillion)
    "NnQag", -- 10^150  (Novemquadragintillion),

    -- Quinquagintillion family (10^153 to 10^180):
    "Qig",   -- 10^153  (Quinquagintillion)
    "UQig",  -- 10^156  (Unquinquagintillion)
    "DQig",  -- 10^159  (Duoquinquagintillion)
    "TQig",  -- 10^162  (Trequinquagintillion)
    "QaQig", -- 10^165  (Quattuorquinquagintillion)
    "QiQig", -- 10^168  (Quinquinquagintillion)
    "SxQig", -- 10^171  (Sexquinquagintillion)
    "SpQig", -- 10^174  (Septenquinquagintillion)
    "OcQig", -- 10^177  (Octoquinquagintillion)
    "NnQig", -- 10^180  (Novemquinquagintillion),

    -- Sexagintillion family (10^183 to 10^210):
    "Sxg",   -- 10^183  (Sexagintillion)
    "USxg",  -- 10^186  (Unsexagintillion)
    "DSxg",  -- 10^189  (Duosexagintillion)
    "TSxg",  -- 10^192  (Tresexagintillion)
    "QaSxg", -- 10^195  (Quattuorsexagintillion)
    "QiSxg", -- 10^198  (Quinsexagintillion)
    "SxSxg", -- 10^201  (Sexsexagintillion)
    "SpSxg", -- 10^204  (Septensexagintillion)
    "OcSxg", -- 10^207  (Octosexagintillion)
    "NnSxg", -- 10^210  (Novemsexagintillion),

    -- Septuagintillion family (10^213 to 10^240):
    "Spg",    -- 10^213  (Septuagintillion)
    "USpg",   -- 10^216  (Unseptuagintillion)
    "DSpg",   -- 10^219  (Duoseptuagintillion)
    "TSpg",   -- 10^222  (Treseptuagintillion)
    "QaSpg",  -- 10^225  (Quattuorseptuagintillion)
    "QiSpg",  -- 10^228  (Quinseptuagintillion)
    "SxSpg",  -- 10^231  (Sexseptuagintillion)
    "SpSpg",  -- 10^234  (Septenseptuagintillion)
    "OcSpg",  -- 10^237  (Octoseptuagintillion)
    "NnSpg",  -- 10^240  (Novemseptuagintillion),

    -- Octogintillion family (10^243 to 10^270):
    "Ocg",    -- 10^243  (Octogintillion)
    "UOcg",   -- 10^246  (Unoctogintillion)
    "DOcg",   -- 10^249  (Duooctogintillion)
    "TOcg",   -- 10^252  (Treoctogintillion)
    "QaOcg",  -- 10^255  (Quattuoroctogintillion)
    "QiOcg",  -- 10^258  (Quinoctogintillion)
    "SxOcg",  -- 10^261  (Sexoctogintillion)
    "SpOcg",  -- 10^264  (Septenoctogintillion)
    "OcOcg",  -- 10^267  (Octooctogintillion)
    "NnOcg",  -- 10^270  (Novemoctogintillion),

    -- Nonagintillion family (10^273 to 10^300):
    "Nog",    -- 10^273  (Nonagintillion)
    "UNog",   -- 10^276  (Unnonagintillion)
    "DNog",   -- 10^279  (Duononagintillion)
    "TNog",   -- 10^282  (Trenonagintillion)
    "QaNog",  -- 10^285  (Quattuornonagintillion)
    "QiNog",  -- 10^288  (Quinnonagintillion)
    "SxNog",  -- 10^291  (Sexnonagintillion)
    "SpNog",  -- 10^294  (Septennonagintillion)
    "OcNog",  -- 10^297  (Octononagintillion)
    "NnNog",  -- 10^300  (Novemnonagintillion),

    -- Centillion family (10^303 to 10^360):
    "Ce",    -- 10^303  (Centillion)
    "UCe",   -- 10^306  (Uncentillion)
    "DCe",   -- 10^309  (Duocentillion)
    "TCe",   -- 10^312  (Trescentillion)
    "QaCe",  -- 10^315  (Quattuorcentillion)
    "QiCe",  -- 10^318  (Quincentillion)
    "SxCe",  -- 10^321  (Sexcentillion)
    "SpCe",  -- 10^324  (Septencentillion)
    "OcCe",  -- 10^327  (Octocentillion)
    "NvCe",  -- 10^330  (Novemcentillion)
    "DcCe",  -- 10^333  (Decicentillion)
    "UDcCe", -- 10^336  (Undecicentillion)
    "TDcCe", -- 10^339  (Tredecicentillion)
    "QaDcCe",-- 10^342  (Quattuordecicentillion)
    "QiDcCe",-- 10^345  (Quindecicentillion)
    "SxDcCe",-- 10^348  (Sedecicentillion)
    "SpDcCe",-- 10^351  (Septendecicentillion)
    "OcDcCe",-- 10^354  (Octodecicentillion)
    "NvDcCe",-- 10^357  (Novemdecicentillion)
    "ViCe",  -- 10^360  (Viginticentillion),

    -- Viginticentillion group (10^363 to 10^390):
    "UViCe",  -- 10^363  (Unviginticentillion)
    "DViCe",  -- 10^366  (Duoviginticentillion)
    "TViCe",  -- 10^369  (Treviginticentillion)
    "QaViCe", -- 10^372  (Quattuorviginticentillion)
    "QiViCe", -- 10^375  (Quinviginticentillion)
    "SxViCe", -- 10^378  (Sexviginticentillion)
    "SpViCe", -- 10^381  (Septenviginticentillion)
    "OcViCe", -- 10^384  (Octoviginticentillion)
    "NnViCe", -- 10^387  (Novemviginticentillion),

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
    "NnTgCe",  -- 10^420  (Novemtriginticentillion),

    -- Quadragintacentillion group (10^423 to 10^450):
    "QagCe",   -- 10^423  (Quadragintacentillion)
    "UQagCe",  -- 10^426  (Unquadragintacentillion)
    "DQagCe",  -- 10^429  (Duoquadragintacentillion)
    "TQagCe",  -- 10^432  (Trequadragintacentillion)
    "QaQagCe", -- 10^435  (Quattuorquadragintacentillion)
    "QiQagCe", -- 10^438  (Quinquadragintacentillion)
    "SxQagCe", -- 10^441  (Sexquadragintacentillion)
    "SpQagCe", -- 10^444  (Septenquadragintacentillion)
    "OcQagCe", -- 10^447  (Octoquadragintacentillion)
    "NnQagCe", -- 10^450  (Novemquadragintacentillion),

    -- Quinquagintacentillion group (10^453 to 10^480):
    "QigCe",   -- 10^453  (Quinquagintacentillion)
    "UQigCe",  -- 10^456  (Unquinquagintacentillion)
    "DQigCe",  -- 10^459  (Duoquinquagintacentillion)
    "TQigCe",  -- 10^462  (Trequinquagintacentillion)
    "QaQigCe", -- 10^465  (Quattuorquinquagintacentillion)
    "QiQigCe", -- 10^468  (Quinquinquagintacentillion)
    "SxQigCe", -- 10^471  (Sexquinquagintacentillion)
    "SpQigCe", -- 10^474  (Septenquinquagintacentillion)
    "OcQigCe", -- 10^477  (Octoquinquagintacentillion)
    "NnQigCe", -- 10^480  (Novemquinquagintacentillion),

    -- Sexagintacentillion group (10^483 to 10^510):
    "SxgCe",   -- 10^483  (Sexagintacentillion)
    "USxgCe",  -- 10^486  (Unsexagintacentillion)
    "DSxgCe",  -- 10^489  (Duosexagintacentillion)
    "TSxgCe",  -- 10^492  (Tresexagintacentillion)
    "QaSxgCe", -- 10^495  (Quattuorsexagintacentillion)
    "QiSxgCe", -- 10^498  (Quinsexagintacentillion)
    "SxSxgCe", -- 10^501  (Sexsexagintacentillion)
    "SpSxgCe", -- 10^504  (Septensexagintacentillion)
    "OcSxgCe", -- 10^507  (Octosexagintacentillion)
    "NnSxgCe", -- 10^510  (Novemsexagintacentillion),

    -- Septuacentillion group (10^513 to 10^540):
    "SpgCe",   -- 10^513  (Septuacentillion)
    "USpgCe",  -- 10^516  (Unseptuacentillion)
    "DSpgCe",  -- 10^519  (Duoseptuacentillion)
    "TSpgCe",  -- 10^522  (Treseptuacentillion)
    "QaSpgCe", -- 10^525  (Quattuorseptuacentillion)
    "QiSpgCe", -- 10^528  (Quinseptuacentillion)
    "SxSpgCe", -- 10^531  (Sexseptuacentillion)
    "SpSpgCe", -- 10^534  (Septenseptuacentillion)
    "OcSpgCe", -- 10^537  (Octoseptuacentillion)
    "NnSpgCe", -- 10^540  (Novemseptuacentillion),

    -- Octogintacentillion group (10^543 to 10^570):
    "OcgCe",   -- 10^543  (Octogintacentillion)
    "UOcgCe",  -- 10^546  (Unoctogintacentillion)
    "DOcgCe",  -- 10^549  (Duooctogintacentillion)
    "TOcgCe",  -- 10^552  (Treoctogintacentillion)
    "QaOcgCe", -- 10^555  (Quattuoroctogintacentillion)
    "QiOcgCe", -- 10^558  (Quinoctogintacentillion)
    "SxOcgCe", -- 10^561  (Sexoctogintacentillion)
    "SpOcgCe", -- 10^564  (Septenoctogintacentillion)
    "OcOcgCe", -- 10^567  (Octooctogintacentillion)
    "NnOcgCe", -- 10^570  (Novemoctogintacentillion),

    -- Nonagintacentillion group (10^573 to 10^600):
    "NogCe",   -- 10^573  (Nonagintacentillion)
    "UNogCe",  -- 10^576  (Unnonagintacentillion)
    "DNogCe",  -- 10^579  (Duononagintacentillion)
    "TNogCe",  -- 10^582  (Trenonagintacentillion)
    "QaNogCe", -- 10^585  (Quattuornonagintacentillion)
    "QiNogCe", -- 10^588  (Quinnonagintacentillion)
    "SxNogCe", -- 10^591  (Sexnonagintacentillion)
    "SpNogCe", -- 10^594  (Septennonagintacentillion)
    "OcNogCe", -- 10^597  (Octononagintacentillion)
    "NnNogCe", -- 10^600  (Novemnonagintacentillion),

    -- Ducentillion group (10^603 to 10^630):
    "Dc",     -- 10^603  (Ducentillion)
    "UDc",    -- 10^606  (Unducentillion)
    "DDc",    -- 10^609  (Duoducentillion)
    "TDc",    -- 10^612  (Treducentillion)
    "QaDc",   -- 10^615  (Quattuorducentillion)
    "QiDc",   -- 10^618  (Quinducentillion)
    "SxDc",   -- 10^621  (Sexducentillion)
    "SpDc",   -- 10^624  (Septenducentillion)
    "OcDc",   -- 10^627  (Octoducentillion)
    "NnDc",   -- 10^630  (Novemducentillion),

    -- Trecentillion family (10^633 to 10^660)
    "Tc",     -- 10^633  (Trecentillion)
    "UTc",    -- 10^636  (Untrecentillion)
    "DTc",    -- 10^639  (Duotrecentillion)
    "TTc",    -- 10^642  (Tretrecentillion)
    "QaTc",   -- 10^645  (Quattuortrecentillion)
    "QiTc",   -- 10^648  (Quintrecentillion)
    "SxTc",   -- 10^651  (Sextrecentillion)
    "SpTc",   -- 10^654  (Septentrecentillion)
    "OcTc",   -- 10^657  (Octotrecentillion)
    "NnTc",   -- 10^660  (Novemtrecentillion),

    -- Vigintitrecentillion group (10^663 to 10^690)
    "ViTc",   -- 10^663  (Vigintitrecentillion)
    "UViTc",  -- 10^666  (Unvigintitrecentillion)
    "DViTc",  -- 10^669  (Duovigintitrecentillion)
    "TViTc",  -- 10^672  (Trevigintitrecentillion)
    "QaViTc", -- 10^675  (Quattuorvigintitrecentillion)
    "QiViTc", -- 10^678  (Quinvigintitrecentillion)
    "SxViTc", -- 10^681  (Sexvigintitrecentillion)
    "SpViTc", -- 10^684  (Septenvigintitrecentillion)
    "OcViTc", -- 10^687  (Octovigintitrecentillion)
    "NnViTc", -- 10^690  (Novemvigintitrecentillion),

    -- Trigintitrecentillion group (10^693 to 10^720)
    "TgTc",    -- 10^693  (Trigintitrecentillion)
    "UTgTc",   -- 10^696  (Untrigintitrecentillion)
    "DTgTc",   -- 10^699  (Duotrigintitrecentillion)
    "TTgTc",   -- 10^702  (Tretrigintitrecentillion)
    "QaTgTc",  -- 10^705  (Quattuortrigintitrecentillion)
    "QiTgTc",  -- 10^708  (Quintrigintitrecentillion)
    "SxTgTc",  -- 10^711  (Sextrigintitrecentillion)
    "SpTgTc",  -- 10^714  (Septentrigintitrecentillion)
    "OcTgTc",  -- 10^717  (Octotrigintitrecentillion)
    "NnTgTc",  -- 10^720  (Novemtrigintitrecentillion),

    -- Quadragintitrecentillion group (10^723 to 10^750)
    "QagTc",   -- 10^723  (Quadragintitrecentillion)
    "UQagTc",  -- 10^726  (Unquadragintitrecentillion)
    "DQagTc",  -- 10^729  (Duoquadragintitrecentillion)
    "TQagTc",  -- 10^732  (Trequadragintitrecentillion)
    "QaQagTc", -- 10^735  (Quattuorquadragintitrecentillion)
    "QiQagTc", -- 10^738  (Quinquadragintitrecentillion)
    "SxQagTc", -- 10^741  (Sexquadragintitrecentillion)
    "SpQagTc", -- 10^744  (Septenquadragintitrecentillion)
    "OcQagTc", -- 10^747  (Octoquadragintitrecentillion)
    "NnQagTc", -- 10^750  (Novemquadragintitrecentillion),

    -- Quinquagintitrecentillion group (10^753 to 10^780)
    "QigTc",   -- 10^753  (Quinquagintitrecentillion)
    "UQigTc",  -- 10^756  (Unquinquagintitrecentillion)
    "DQigTc",  -- 10^759  (Duoquinquagintitrecentillion)
    "TQigTc",  -- 10^762  (Trequinquagintitrecentillion)
    "QaQigTc", -- 10^765  (Quattuorquinquagintitrecentillion)
    "QiQigTc", -- 10^768  (Quinquinquagintitrecentillion)
    "SxQigTc", -- 10^771  (Sexquinquagintitrecentillion)
    "SpQigTc", -- 10^774  (Septenquinquagintitrecentillion)
    "OcQigTc", -- 10^777  (Octoquinquagintitrecentillion)
    "NnQigTc", -- 10^780  (Novemquinquagintitrecentillion),

    -- Sexagintitrecentillion group (10^783 to 10^810)
    "SxgTc",   -- 10^783  (Sexagintitrecentillion)
    "USxgTc",  -- 10^786  (Unsexagintitrecentillion)
    "DSxgTc",  -- 10^789  (Duosexagintitrecentillion)
    "TSxgTc",  -- 10^792  (Tresexagintitrecentillion)
    "QaSxgTc", -- 10^795  (Quattuorsexagintitrecentillion)
    "QiSxgTc", -- 10^798  (Quinsexagintitrecentillion)
    "SxSxgTc", -- 10^801  (Sexsexagintitrecentillion)
    "SpSxgTc", -- 10^804  (Septensexagintitrecentillion)
    "OcSxgTc", -- 10^807  (Octosexagintitrecentillion)
    "NnSxgTc", -- 10^810  (Novemsexagintitrecentillion),

    -- Septuagintitrecentillion group (10^813 to 10^840)
    "SpgTc",    -- 10^813  (Septuagintitrecentillion)
    "USpgTc",   -- 10^816  (Unseptuagintitrecentillion)
    "DSpgTc",   -- 10^819  (Duoseptuagintitrecentillion)
    "TSpgTc",   -- 10^822  (Treseptuagintitrecentillion)
    "QaSpgTc",  -- 10^825  (Quattuorseptuagintitrecentillion)
    "QiSpgTc",  -- 10^828  (Quinseptuagintitrecentillion)
    "SxSpgTc",  -- 10^831  (Sexseptuagintitrecentillion)
    "SpSpgTc",  -- 10^834  (Septenseptuagintitrecentillion)
    "OcSpgTc",  -- 10^837  (Octoseptuagintitrecentillion)
    "NnSpgTc",  -- 10^840  (Novemseptuagintitrecentillion),

    -- Octogintitrecentillion group (10^843 to 10^870)
    "OcgTc",    -- 10^843  (Octogintitrecentillion)
    "UOcgTc",   -- 10^846  (Unoctogintitrecentillion)
    "DOcgTc",   -- 10^849  (Duooctogintitrecentillion)
    "TOcgTc",   -- 10^852  (Treoctogintitrecentillion)
    "QaOcgTc",  -- 10^855  (Quattuoroctogintitrecentillion)
    "QiOcgTc",  -- 10^858  (Quinoctogintitrecentillion)
    "SxOcgTc",  -- 10^861  (Sexoctogintitrecentillion)
    "SpOcgTc",  -- 10^864  (Septenoctogintitrecentillion)
    "OcOcgTc",  -- 10^867  (Octooctogintitrecentillion)
    "NnOcgTc",  -- 10^870  (Novemoctogintitrecentillion),

    -- Nonagintitrecentillion group (10^873 to 10^900)
    "NogTc",    -- 10^873  (Nonagintitrecentillion)
    "UNogTc",   -- 10^876  (Unnonagintitrecentillion)
    "DNogTc",   -- 10^879  (Duononagintitrecentillion)
    "TNogTc",   -- 10^882  (Trenonagintitrecentillion)
    "QaNogTc",  -- 10^885  (Quattuornonagintitrecentillion)
    "QiNogTc",  -- 10^888  (Quinnonagintitrecentillion)
    "SxNogTc",  -- 10^891  (Sexnonagintitrecentillion)
    "SpNogTc",  -- 10^894  (Septennonagintitrecentillion)
    "OcNogTc",  -- 10^897  (Octononagintitrecentillion)
    "NnNogTc",  -- 10^900  (Novemnonagintitrecentillion),

    -- Quadringentillion family (10^903 to 10^930)
    "QaC",     -- 10^903  (Quadringentillion)
    "UQaC",    -- 10^906  (Unquadringentillion)
    "DQaC",    -- 10^909  (Duoquadringentillion)
    "TQaC",    -- 10^912  (Trequadringentillion)
    "QaQaC",   -- 10^915  (Quattuorquadringentillion)
    "QiQaC",   -- 10^918  (Quinquadringentillion)
    "SxQaC",   -- 10^921  (Sexquadringentillion)
    "SpQaC",   -- 10^924  (Septenquadringentillion)
    "OcQaC",   -- 10^927  (Octoquadringentillion)
    "NnQaC",   -- 10^930  (Novemquadringentillion),

    -- Vigintiquadringentillion group (10^933 to 10^960)
    "ViQaC",   -- 10^933  (Vigintiquadringentillion)
    "UViQaC",  -- 10^936  (Unvigintiquadringentillion)
    "DViQaC",  -- 10^939  (Duovigintiquadringentillion)
    "TViQaC",  -- 10^942  (Trevigintiquadringentillion)
    "QaViQaC", -- 10^945  (Quattuorvigintiquadringentillion)
    "QiViQaC", -- 10^948  (Quinvigintiquadringentillion)
    "SxViQaC", -- 10^951  (Sexvigintiquadringentillion)
    "SpViQaC", -- 10^954  (Septenvigintiquadringentillion)
    "OcViQaC", -- 10^957  (Octovigintiquadringentillion)
    "NnViQaC", -- 10^960  (Novemvigintiquadringentillion),

    -- Trigintiquadringentillion group (10^963 to 10^990)
    "TgQaC",    -- 10^963  (Trigintiquadringentillion)
    "UTgQaC",   -- 10^966  (Untrigintiquadringentillion)
    "DTgQaC",   -- 10^969  (Duotrigintiquadringentillion)
    "TTgQaC",   -- 10^972  (Tretrigintiquadringentillion)
    "QaTgQaC",  -- 10^975  (Quattuortrigintiquadringentillion)
    "QiTgQaC",  -- 10^978  (Quintrigintiquadringentillion)
    "SxTgQaC",  -- 10^981  (Sextrigintiquadringentillion)
    "SpTgQaC",  -- 10^984  (Septentrigintiquadringentillion)
    "OcTgQaC",  -- 10^987  (Octotrigintiquadringentillion)
    "NnTgQaC",  -- 10^990  (Novemtrigintiquadringentillion),

    -- Quadragintiquadringentillion group (10^993 to 10^1020)
    "QagQaC",   -- 10^993  (Quadragintiquadringentillion)
    "UQagQaC",  -- 10^996  (Unquadragintiquadringentillion)
    "DQagQaC",  -- 10^999  (Duoquadragintiquadringentillion)
    "TQagQaC",  -- 10^1002 (Trequadragintiquadringentillion)
    "QaQagQaC", -- 10^1005 (Quattuorquadragintiquadringentillion)
    "QiQagQaC", -- 10^1008 (Quinquadragintiquadringentillion)
    "SxQagQaC", -- 10^1011 (Sexquadragintiquadringentillion)
    "SpQagQaC", -- 10^1014 (Septenquadragintiquadringentillion)
    "OcQagQaC", -- 10^1017 (Octoquadragintiquadringentillion)
    "NnQagQaC", -- 10^1020 (Novemquadragintiquadringentillion),

    -- Quinquagintiquadringentillion group (10^1023 to 10^1050)
    "QigQaC",   -- 10^1023 (Quinquagintiquadringentillion)
    "UQigQaC",  -- 10^1026 (Unquinquagintiquadringentillion)
    "DQigQaC",  -- 10^1029 (Duoquinquagintiquadringentillion)
    "TQigQaC",  -- 10^1032 (Trequinquagintiquadringentillion)
    "QaQigQaC", -- 10^1035 (Quattuorquinquagintiquadringentillion)
    "QiQigQaC", -- 10^1038 (Quinquinquagintiquadringentillion)
    "SxQigQaC", -- 10^1041 (Sexquinquagintiquadringentillion)
    "SpQigQaC", -- 10^1044 (Septenquinquagintiquadringentillion)
    "OcQigQaC", -- 10^1047 (Octoquinquagintiquadringentillion)
    "NnQigQaC", -- 10^1050 (Novemquinquagintiquadringentillion),

    -- Sexagintiquadringentillion group (10^1053 to 10^1080)
    "SxgQaC",   -- 10^1053 (Sexagintiquadringentillion)
    "USxgQaC",  -- 10^1056 (Unsexagintiquadringentillion)
    "DSxgQaC",  -- 10^1059 (Duosexagintiquadringentillion)
    "TSxgQaC",  -- 10^1062 (Tresexagintiquadringentillion)
    "QaSxgQaC", -- 10^1065 (Quattuorsexagintiquadringentillion)
    "QiSxgQaC", -- 10^1068 (Quinsexagintiquadringentillion)
    "SxSxgQaC", -- 10^1071 (Sexsexagintiquadringentillion)
    "SpSxgQaC", -- 10^1074 (Septensexagintiquadringentillion)
    "OcSxgQaC", -- 10^1077 (Octosexagintiquadringentillion)
    "NnSxgQaC", -- 10^1080 (Novemsexagintiquadringentillion),

    -- Septuagintiquadringentillion group (10^1083 to 10^1110)
    "SpgQaC",   -- 10^1083 (Septuagintiquadringentillion)
    "USpgQaC",  -- 10^1086 (Unseptuagintiquadringentillion)
    "DSpgQaC",  -- 10^1089 (Duoseptuagintiquadringentillion)
    "TSpgQaC",  -- 10^1092 (Treseptuagintiquadringentillion)
    "QaSpgQaC", -- 10^1095 (Quattuorseptuagintiquadringentillion)
    "QiSpgQaC", -- 10^1098 (Quinseptuagintiquadringentillion)
    "SxSpgQaC", -- 10^1101 (Sexseptuagintiquadringentillion)
    "SpSpgQaC", -- 10^1104 (Septenseptuagintiquadringentillion)
    "OcSpgQaC", -- 10^1107 (Octoseptuagintiquadringentillion)
    "NnSpgQaC", -- 10^1110 (Novemseptuagintiquadringentillion),

    -- Octogintiquadringentillion group (10^1113 to 10^1140)
    "OcgQaC",   -- 10^1113 (Octogintiquadringentillion)
    "UOcgQaC",  -- 10^1116 (Unoctogintiquadringentillion)
    "DOcgQaC",  -- 10^1119 (Duooctogintiquadringentillion)
    "TOcgQaC",  -- 10^1122 (Treoctogintiquadringentillion)
    "QaOcgQaC", -- 10^1125 (Quattuoroctogintiquadringentillion)
    "QiOcgQaC", -- 10^1128 (Quinoctogintiquadringentillion)
    "SxOcgQaC", -- 10^1131 (Sexoctogintiquadringentillion)
    "SpOcgQaC", -- 10^1134 (Septenoctogintiquadringentillion)
    "OcOcgQaC", -- 10^1137 (Octooctogintiquadringentillion)
    "NnOcgQaC", -- 10^1140 (Novemoctogintiquadringentillion),

    -- Nonagintiquadringentillion group (10^1143 to 10^1170)
    "NogQaC",   -- 10^1143 (Nonagintiquadringentillion)
    "UNogQaC",  -- 10^1146 (Unnonagintiquadringentillion)
    "DNogQaC",  -- 10^1149 (Duononagintiquadringentillion)
    "TNogQaC",  -- 10^1152 (Trenonagintiquadringentillion)
    "QaNogQaC", -- 10^1155 (Quattuornonagintiquadringentillion)
    "QiNogQaC", -- 10^1158 (Quinnonagintiquadringentillion)
    "SxNogQaC", -- 10^1161 (Sexnonagintiquadringentillion)
    "SpNogQaC", -- 10^1164 (Septennonagintiquadringentillion)
    "OcNogQaC", -- 10^1167 (Octononagintiquadringentillion)
    "NnNogQaC", -- 10^1170 (Novemnonagintiquadringentillion),

    -- Centiquadringentillion group (10^1173 to 10^1200)
    "CeQaC",    -- 10^1173 (Centiquadringentillion)
    "UCeQaC",   -- 10^1176 (Uncentiquadringentillion)
    "DCeQaC",   -- 10^1179 (Duocentiquadringentillion)
    "TCeQaC",   -- 10^1182 (Trescentiquadringentillion)
    "QaCeQaC",  -- 10^1185 (Quattuorcentiquadringentillion)
    "QiCeQaC",  -- 10^1188 (Quincentiquadringentillion)
    "SxCeQaC",  -- 10^1191 (Sexcentiquadringentillion)
    "SpCeQaC",  -- 10^1194 (Septencentiquadringentillion)
    "OcCeQaC",  -- 10^1197 (Octocentiquadringentillion)
    "NvCeQaC",  -- 10^1200 (Novemcentiquadringentillion),

    -- Quingentillion family (10^1203 to 10^1230) --
    "QiC",     -- 10^1203 (Quingentillion)
    "UQiC",    -- 10^1206 (Unquingentillion)
    "DQiC",    -- 10^1209 (Duoquingentillion)
    "TQiC",    -- 10^1212 (Trequingentillion)
    "QaQiC",   -- 10^1215 (Quattuorquingentillion)
    "QiQiC",   -- 10^1218 (Quinquingentillion)
    "SxQiC",   -- 10^1221 (Sexquingentillion)
    "SpQiC",   -- 10^1224 (Septenquingentillion)
    "OcQiC",   -- 10^1227 (Octoquingentillion)
    "NnQiC",   -- 10^1230 (Novemquingentillion),

    -- Vigintiquingentillion group (10^1233 to 10^1260)
    "ViQiC",   -- 10^1233 (Vigintiquingentillion)
    "UViQiC",  -- 10^1236 (Unvigintiquingentillion)
    "DViQiC",  -- 10^1239 (Duovigintiquingentillion)
    "TViQiC",  -- 10^1242 (Trevigintiquingentillion)
    "QaViQiC", -- 10^1245 (Quattuorvigintiquingentillion)
    "QiViQiC", -- 10^1248 (Quinvigintiquingentillion)
    "SxViQiC", -- 10^1251 (Sexvigintiquingentillion)
    "SpViQiC", -- 10^1254 (Septenvigintiquingentillion)
    "OcViQiC", -- 10^1257 (Octovigintiquingentillion)
    "NnViQiC", -- 10^1260 (Novemvigintiquingentillion),

    -- Trigintiquingentillion Group (10^1263-10^1290)
    "TgQg",    -- 10^1263 (Trigintiquingentillion)
    "UTgQg",   -- 10^1266 (Untrigintiquingentillion)
    "DTgQg",   -- 10^1269 (Duotrigintiquingentillion)
    "TTgQg",   -- 10^1272 (Tretrigintiquingentillion)
    "QaTgQg",  -- 10^1275 (Quattuortrigintiquingentillion)
    "QiTgQg",  -- 10^1278 (Quintrigintiquingentillion)
    "SxTgQg",  -- 10^1281 (Sextrigintiquingentillion)
    "SpTgQg",  -- 10^1284 (Septentrigintiquingentillion)
    "OcTgQg",  -- 10^1287 (Octotrigintiquingentillion)
    "NnTgQg",  -- 10^1290 (Novemtrigintiquingentillion),

    -- Quadragintiquingentillion Group (10^1293-10^1320)
    "QagQg",   -- 10^1293 (Quadragintiquingentillion)
    "UQagQg",  -- 10^1296 (Unquadragintiquingentillion)
    "DQagQg",  -- 10^1299 (Duoquadragintiquingentillion)
    "TQagQg",  -- 10^1302 (Trequadragintiquingentillion)
    "QaQagQg", -- 10^1305 (Quattuorquadragintiquingentillion)
    "QiQagQg", -- 10^1308 (Quinquadragintiquingentillion)
    "SxQagQg", -- 10^1311 (Sexquadragintiquingentillion)
    "SpQagQg", -- 10^1314 (Septenquadragintiquingentillion)
    "OcQagQg", -- 10^1317 (Octoquadragintiquingentillion)
    "NnQagQg", -- 10^1320 (Novemquadragintiquingentillion),

    -- Quinquagintiquingentillion Group (10^1323-10^1350)
    "QigQg",   -- 10^1323 (Quinquagintiquingentillion)
    "UQigQg",  -- 10^1326 (Unquinquagintiquingentillion)
    "DQigQg",  -- 10^1329 (Duoquinquagintiquingentillion)
    "TQigQg",  -- 10^1332 (Trequinquagintiquingentillion)
    "QaQigQg", -- 10^1335 (Quattuorquinquagintiquingentillion)
    "QiQigQg", -- 10^1338 (Quinquinquagintiquingentillion)
    "SxQigQg", -- 10^1341 (Sexquinquagintiquingentillion)
    "SpQigQg", -- 10^1344 (Septenquinquagintiquingentillion)
    "OcQigQg", -- 10^1347 (Octoquinquagintiquingentillion)
    "NnQigQg", -- 10^1350 (Novemquinquagintiquingentillion),

    -- Sexagintiquingentillion Group (10^1353-10^1380)
    "SxgQg",   -- 10^1353 (Sexagintiquingentillion)
    "USxgQg",  -- 10^1356 (Unsexagintiquingentillion)
    "DSxgQg",  -- 10^1359 (Duosexagintiquingentillion)
    "TSxgQg",  -- 10^1362 (Tresexagintiquingentillion)
    "QaSxgQg", -- 10^1365 (Quattuorsexagintiquingentillion)
    "QiSxgQg", -- 10^1368 (Quinsexagintiquingentillion)
    "SxSxgQg", -- 10^1371 (Sexsexagintiquingentillion)
    "SpSxgQg", -- 10^1374 (Septensexagintiquingentillion)
    "OcSxgQg", -- 10^1377 (Octosexagintiquingentillion)
    "NnSxgQg", -- 10^1380 (Novemsexagintiquingentillion),

    -- Septuagintiquingentillion Group (10^1383-10^1410)
    "SpgQg",   -- 10^1383 (Septuagintiquingentillion)
    "USpgQg",  -- 10^1386 (Unseptuagintiquingentillion)
    "DSpgQg",  -- 10^1389 (Duoseptuagintiquingentillion)
    "TSpgQg",  -- 10^1392 (Treseptuagintiquingentillion)
    "QaSpgQg", -- 10^1395 (Quattuorseptuagintiquingentillion)
    "QiSpgQg", -- 10^1398 (Quinseptuagintiquingentillion)
    "SxSpgQg", -- 10^1401 (Sexseptuagintiquingentillion)
    "SpSpgQg", -- 10^1404 (Septenseptuagintiquingentillion)
    "OcSpgQg", -- 10^1407 (Octoseptuagintiquingentillion)
    "NnSpgQg", -- 10^1410 (Novemseptuagintiquingentillion),

    -- Octogintiquingentillion Group (10^1413-10^1440)
    "OcgQg",   -- 10^1413 (Octogintiquingentillion)
    "UOcgQg",  -- 10^1416 (Unoctogintiquingentillion)
    "DOcgQg",  -- 10^1419 (Duooctogintiquingentillion)
    "TOcgQg",  -- 10^1422 (Treoctogintiquingentillion)
    "QaOcgQg", -- 10^1425 (Quattuoroctogintiquingentillion)
    "QiOcgQg", -- 10^1428 (Quinoctogintiquingentillion)
    "SxOcgQg", -- 10^1431 (Sexoctogintiquingentillion)
    "SpOcgQg", -- 10^1434 (Septenoctogintiquingentillion)
    "OcOcgQg", -- 10^1437 (Octooctogintiquingentillion)
    "NnOcgQg", -- 10^1440 (Novemoctogintiquingentillion),

    -- Nonagintiquingentillion Group (10^1443-10^1470)
    "NogQg",   -- 10^1443 (Nonagintiquingentillion)
    "UNogQg",  -- 10^1446 (Unnonagintiquingentillion)
    "DNogQg",  -- 10^1449 (Duononagintiquingentillion)
    "TNogQg",  -- 10^1452 (Trenonagintiquingentillion)
    "QaNogQg", -- 10^1455 (Quattuornonagintiquingentillion)
    "QiNogQg", -- 10^1458 (Quinnonagintiquingentillion)
    "SxNogQg", -- 10^1461 (Sexnonagintiquingentillion)
    "SpNogQg", -- 10^1464 (Septennonagintiquingentillion)
    "OcNogQg", -- 10^1467 (Octononagintiquingentillion)
    "NnNogQg", -- 10^1470 (Novemnonagintiquingentillion),

    -- Centiquingentillion Group (10^1473-10^1500)
    "CeQg",    -- 10^1473 (Centiquingentillion)
    "UCeQg",   -- 10^1476 (Uncentiquingentillion)
    "DCeQg",   -- 10^1479 (Duocentiquingentillion)
    "TCeQg",   -- 10^1482 (Trescentiquingentillion)
    "QaCeQg",  -- 10^1485 (Quattuorcentiquingentillion)
    "QiCeQg",  -- 10^1488 (Quincentiquingentillion)
    "SxCeQg",  -- 10^1491 (Sexcentiquingentillion)
    "SpCeQg",  -- 10^1494 (Septencentiquingentillion)
    "OcCeQg",  -- 10^1497 (Octocentiquingentillion)
    "NvCeQg",  -- 10^1500 (Novemcentiquingentillion),

    -- Quingentillion Group (10^1503-10^1530)
    "Qg",     -- 10^1503 (Quingentillion)
    "UQg",    -- 10^1506 (Unquingentillion)
    "DQg",    -- 10^1509 (Duoquingentillion)
    "TQg",    -- 10^1512 (Trequingentillion)
    "QaQg",   -- 10^1515 (Quattuorquingentillion)
    "QiQg",   -- 10^1518 (Quinquingentillion)
    "SxQg",   -- 10^1521 (Sexquingentillion)
    "SpQg",   -- 10^1524 (Septenquingentillion)
    "OcQg",   -- 10^1527 (Octoquingentillion)
    "NnQg",   -- 10^1530 (Novemquingentillion),

    -- Vigintiquingentillion Group (10^1533-10^1560)
    "ViQg",   -- 10^1533
    "UViQg",  -- 10^1536
    "DViQg",  -- 10^1539
    "TViQg",  -- 10^1542
    "QaViQg", -- 10^1545
    "QiViQg", -- 10^1548
    "SxViQg", -- 10^1551
    "SpViQg", -- 10^1554
    "OcViQg", -- 10^1557
    "NnViQg", -- 10^1560,

    -- Trigintiquingentillion (10^1563-10^1590)
    "TgQg",    -- 10^1563
    "UTgQg",   -- 10^1566
    "DTgQg",   -- 10^1569
    "TTgQg",   -- 10^1572
    "QaTgQg",  -- 10^1575
    "QiTgQg",  -- 10^1578
    "SxTgQg",  -- 10^1581
    "SpTgQg",  -- 10^1584
    "OcTgQg",  -- 10^1587
    "NnTgQg",  -- 10^1590,

    -- Quadragintiquingentillion (10^1593-10^1620)
    "QagQg",   -- 10^1593
    "UQagQg",  -- 10^1596
    "DQagQg",  -- 10^1599
    "TQagQg",  -- 10^1602
    "QaQagQg", -- 10^1605
    "QiQagQg", -- 10^1608
    "SxQagQg", -- 10^1611
    "SpQagQg", -- 10^1614
    "OcQagQg", -- 10^1617
    "NnQagQg", -- 10^1620,

    -- Quinquagintiquingentillion (10^1623-10^1650)
    "QigQg",   -- 10^1623
    "UQigQg",  -- 10^1626
    "DQigQg",  -- 10^1629
    "TQigQg",  -- 10^1632
    "QaQigQg", -- 10^1635
    "QiQigQg", -- 10^1638
    "SxQigQg", -- 10^1641
    "SpQigQg", -- 10^1644
    "OcQigQg", -- 10^1647
    "NnQigQg", -- 10^1650,

    -- Sexagintiquingentillion (10^1653-10^1680)
    "SxgQg",   -- 10^1653
    "USxgQg",  -- 10^1656
    "DSxgQg",  -- 10^1659
    "TSxgQg",  -- 10^1662
    "QaSxgQg", -- 10^1665
    "QiSxgQg", -- 10^1668
    "SxSxgQg", -- 10^1671
    "SpSxgQg", -- 10^1674
    "OcSxgQg", -- 10^1677
    "NnSxgQg", -- 10^1680,

    -- Septuagintiquingentillion (10^1683-10^1710)
    "SpgQg",   -- 10^1683
    "USpgQg",  -- 10^1686
    "DSpgQg",  -- 10^1689
    "TSpgQg",  -- 10^1692
    "QaSpgQg", -- 10^1695
    "QiSpgQg", -- 10^1698
    "SxSpgQg", -- 10^1701
    "SpSpgQg", -- 10^1704
    "OcSpgQg", -- 10^1707
    "NnSpgQg", -- 10^1710,

    -- Octogintiquingentillion (10^1713-10^1740)
    "OcgQg",   -- 10^1713
    "UOcgQg",  -- 10^1716
    "DOcgQg",  -- 10^1719
    "TOcgQg",  -- 10^1722
    "QaOcgQg", -- 10^1725
    "QiOcgQg", -- 10^1728
    "SxOcgQg", -- 10^1731
    "SpOcgQg", -- 10^1734
    "OcOcgQg", -- 10^1737
    "NnOcgQg", -- 10^1740,

    -- Nonagintiquingentillion (10^1743-10^1770)
    "NogQg",   -- 10^1743
    "UNogQg",  -- 10^1746
    "DNogQg",  -- 10^1749
    "TNogQg",  -- 10^1752
    "QaNogQg", -- 10^1755
    "QiNogQg", -- 10^1758
    "SxNogQg", -- 10^1761
    "SpNogQg", -- 10^1764
    "OcNogQg", -- 10^1767
    "NnNogQg", -- 10^1770,

    -- Centiquingentillion (10^1773-10^1800)
    "CeQg",    -- 10^1773
    "UCeQg",   -- 10^1776
    "DCeQg",   -- 10^1779
    "TCeQg",   -- 10^1782
    "QaCeQg",  -- 10^1785
    "QiCeQg",  -- 10^1788
    "SxCeQg",  -- 10^1791
    "SpCeQg",  -- 10^1794
    "OcCeQg",  -- 10^1797
    "NvCeQg",  -- 10^1800,

    -- ===== Sescentillion Family (10^1803-10^2103) =====
    -- Base Group (10^1803-10^1830)
    "Sc",     -- 10^1803
    "USc",    -- 10^1806
    "DSc",    -- 10^1809
    "TSc",    -- 10^1812
    "QaSc",   -- 10^1815
    "QiSc",   -- 10^1818
    "SxSc",   -- 10^1821
    "SpSc",   -- 10^1824
    "OcSc",   -- 10^1827
    "NnSc",   -- 10^1830,

    -- Vigintisescentillion (10^1833-10^1860)
    "ViSc",   -- 10^1833
    "UViSc",  -- 10^1836
    "DViSc",  -- 10^1839
    "TViSc",  -- 10^1842
    "QaViSc", -- 10^1845
    "QiViSc", -- 10^1848
    "SxViSc", -- 10^1851
    "SpViSc", -- 10^1854
    "OcViSc", -- 10^1857
    "NnViSc", -- 10^1860,

    -- Trigintisescentillion Group (10^1863-10^1890)
    "TgSc",    -- 10^1863 (Trigintisescentillion)
    "UTgSc",   -- 10^1866 (Untrigintisescentillion)
    "DTgSc",   -- 10^1869 (Duotrigintisescentillion)
    "TTgSc",   -- 10^1872 (Tretrigintisescentillion)
    "QaTgSc",  -- 10^1875 (Quattuortrigintisescentillion)
    "QiTgSc",  -- 10^1878 (Quintrigintisescentillion)
    "SxTgSc",  -- 10^1881 (Sextrigintisescentillion)
    "SpTgSc",  -- 10^1884 (Septentrigintisescentillion)
    "OcTgSc",  -- 10^1887 (Octotrigintisescentillion)
    "NnTgSc",  -- 10^1890 (Novemtrigintisescentillion),

    -- Quadragintisescentillion Group (10^1893-10^1920)
    "QagSc",   -- 10^1893 (Quadragintisescentillion)
    "UQagSc",  -- 10^1896 (Unquadragintisescentillion)
    "DQagSc",  -- 10^1899 (Duoquadragintisescentillion)
    "TQagSc",  -- 10^1902 (Trequadragintisescentillion)
    "QaQagSc", -- 10^1905 (Quattuorquadragintisescentillion)
    "QiQagSc", -- 10^1908 (Quinquadragintisescentillion)
    "SxQagSc", -- 10^1911 (Sexquadragintisescentillion)
    "SpQagSc", -- 10^1914 (Septenquadragintisescentillion)
    "OcQagSc", -- 10^1917 (Octoquadragintisescentillion)
    "NnQagSc", -- 10^1920 (Novemquadragintisescentillion),

    -- Quinquagintisescentillion Group (10^1923-10^1950)
    "QigSc",   -- 10^1923 (Quinquagintisescentillion)
    "UQigSc",  -- 10^1926 (Unquinquagintisescentillion)
    "DQigSc",  -- 10^1929 (Duoquinquagintisescentillion)
    "TQigSc",  -- 10^1932 (Trequinquagintisescentillion)
    "QaQigSc", -- 10^1935 (Quattuorquinquagintisescentillion)
    "QiQigSc", -- 10^1938 (Quinquinquagintisescentillion)
    "SxQigSc", -- 10^1941 (Sexquinquagintisescentillion)
    "SpQigSc", -- 10^1944 (Septenquinquagintisescentillion)
    "OcQigSc", -- 10^1947 (Octoquinquagintisescentillion)
    "NnQigSc", -- 10^1950 (Novemquinquagintisescentillion),

    -- Sexagintisescentillion Group (10^1953-10^1980)
    "SxgSc",   -- 10^1953 (Sexagintisescentillion)
    "USxgSc",  -- 10^1956 (Unsexagintisescentillion)
    "DSxgSc",  -- 10^1959 (Duosexagintisescentillion)
    "TSxgSc",  -- 10^1962 (Tresexagintisescentillion)
    "QaSxgSc", -- 10^1965 (Quattuorsexagintisescentillion)
    "QiSxgSc", -- 10^1968 (Quinsexagintisescentillion)
    "SxSxgSc", -- 10^1971 (Sexsexagintisescentillion)
    "SpSxgSc", -- 10^1974 (Septensexagintisescentillion)
    "OcSxgSc", -- 10^1977 (Octosexagintisescentillion)
    "NnSxgSc", -- 10^1980 (Novemsexagintisescentillion),

    -- Septuagintisescentillion Group (10^1983-10^2010)
    "SpgSc",   -- 10^1983 (Septuagintisescentillion)
    "USpgSc",  -- 10^1986 (Unseptuagintisescentillion)
    "DSpgSc",  -- 10^1989 (Duoseptuagintisescentillion)
    "TSpgSc",  -- 10^1992 (Treseptuagintisescentillion)
    "QaSpgSc", -- 10^1995 (Quattuorseptuagintisescentillion)
    "QiSpgSc", -- 10^1998 (Quinseptuagintisescentillion)
    "SxSpgSc", -- 10^2001 (Sexseptuagintisescentillion)
    "SpSpgSc", -- 10^2004 (Septenseptuagintisescentillion)
    "OcSpgSc", -- 10^2007 (Octoseptuagintisescentillion)
    "NnSpgSc", -- 10^2010 (Novemseptuagintisescentillion),

    -- Octogintisescentillion Group (10^2013-10^2040)
    "OcgSc",   -- 10^2013 (Octogintisescentillion)
    "UOcgSc",  -- 10^2016 (Unoctogintisescentillion)
    "DOcgSc",  -- 10^2019 (Duooctogintisescentillion)
    "TOcgSc",  -- 10^2022 (Treoctogintisescentillion)
    "QaOcgSc", -- 10^2025 (Quattuoroctogintisescentillion)
    "QiOcgSc", -- 10^2028 (Quinoctogintisescentillion)
    "SxOcgSc", -- 10^2031 (Sexoctogintisescentillion)
    "SpOcgSc", -- 10^2034 (Septenoctogintisescentillion)
    "OcOcgSc", -- 10^2037 (Octooctogintisescentillion)
    "NnOcgSc", -- 10^2040 (Novemoctogintisescentillion),

    -- Nonagintisescentillion Group (10^2043-10^2070)
    "NogSc",   -- 10^2043 (Nonagintisescentillion)
    "UNogSc",  -- 10^2046 (Unnonagintisescentillion)
    "DNogSc",  -- 10^2049 (Duononagintisescentillion)
    "TNogSc",  -- 10^2052 (Trenonagintisescentillion)
    "QaNogSc", -- 10^2055 (Quattuornonagintisescentillion)
    "QiNogSc", -- 10^2058 (Quinnonagintisescentillion)
    "SxNogSc", -- 10^2061 (Sexnonagintisescentillion)
    "SpNogSc", -- 10^2064 (Septennonagintisescentillion)
    "OcNogSc", -- 10^2067 (Octononagintisescentillion)
    "NnNogSc", -- 10^2070 (Novemnonagintisescentillion),

    -- Centisescentillion Group (10^2073-10^2100)
    "CeSc",    -- 10^2073 (Centisescentillion)
    "UCeSc",   -- 10^2076 (Uncentisescentillion)
    "DCeSc",   -- 10^2079 (Duocentisescentillion)
    "TCeSc",   -- 10^2082 (Trescentisescentillion)
    "QaCeSc",  -- 10^2085 (Quattuorcentisescentillion)
    "QiCeSc",  -- 10^2088 (Quincentisescentillion)
    "SxCeSc",  -- 10^2091 (Sexcentisescentillion)
    "SpCeSc",  -- 10^2094 (Septencentisescentillion)
    "OcCeSc",  -- 10^2097 (Octocentisescentillion)
    "NvCeSc",  -- 10^2100 (Novemcentisescentillion),

    -- Base Group (10^2103-10^2130)
    "Spt",    -- 10^2103 (Septingentillion)
    "USpt",   -- 10^2106 (Unseptingentillion)
    "DSpt",   -- 10^2109 (Duoseptingentillion)
    "TSpt",   -- 10^2112 (Treseptingentillion)
    "QaSpt",  -- 10^2115 (Quattuorseptingentillion)
    "QiSpt",  -- 10^2118 (Quinseptingentillion)
    "SxSpt",  -- 10^2121 (Sexseptingentillion)
    "SpSpt",  -- 10^2124 (Septenseptingentillion)
    "OcSpt",  -- 10^2127 (Octoseptingentillion)
    "NnSpt",  -- 10^2130 (Novemseptingentillion),

    -- Vigintiseptingentillion Group (10^2133-10^2160)
    "ViSpt",  -- 10^2133 (Vigintiseptingentillion)
    "UViSpt", -- 10^2136 (Unvigintiseptingentillion)
    "DViSpt", -- 10^2139 (Duovigintiseptingentillion)
    "TViSpt", -- 10^2142 (Trevigintiseptingentillion)
    "QaViSpt",-- 10^2145 (Quattuorvigintiseptingentillion)
    "QiViSpt",-- 10^2148 (Quinvigintiseptingentillion)
    "SxViSpt",-- 10^2151 (Sexvigintiseptingentillion)
    "SpViSpt",-- 10^2154 (Septenvigintiseptingentillion)
    "OcViSpt",-- 10^2157 (Octovigintiseptingentillion)
    "NnViSpt",-- 10^2160 (Novemvigintiseptingentillion),

    -- Trigintiseptingentillion Group (10^2163-10^2190)
    "TgSpt",    -- 10^2163
    "UTgSpt",   -- 10^2166
    "DTgSpt",   -- 10^2169
    "TTgSpt",   -- 10^2172
    "QaTgSpt",  -- 10^2175
    "QiTgSpt",  -- 10^2178
    "SxTgSpt",  -- 10^2181
    "SpTgSpt",  -- 10^2184
    "OcTgSpt",  -- 10^2187
    "NnTgSpt",  -- 10^2190,

    -- Quadragintiseptingentillion (10^2193-10^2220)
    "QagSpt",   -- 10^2193
    "UQagSpt",  -- 10^2196
    "DQagSpt",  -- 10^2199
    "TQagSpt",  -- 10^2202
    "QaQagSpt", -- 10^2205
    "QiQagSpt", -- 10^2208
    "SxQagSpt", -- 10^2211
    "SpQagSpt", -- 10^2214
    "OcQagSpt", -- 10^2217
    "NnQagSpt", -- 10^2220,

    -- Quinquagintiseptingentillion (10^2223-10^2250)
    "QigSpt",   -- 10^2223
    "UQigSpt",  -- 10^2226
    "DQigSpt",  -- 10^2229
    "TQigSpt",  -- 10^2232
    "QaQigSpt", -- 10^2235
    "QiQigSpt", -- 10^2238
    "SxQigSpt", -- 10^2241
    "SpQigSpt", -- 10^2244
    "OcQigSpt", -- 10^2247
    "NnQigSpt", -- 10^2250,

    -- Sexagintiseptingentillion (10^2253-10^2280)
    "SxgSpt",   -- 10^2253
    "USxgSpt",  -- 10^2256
    "DSxgSpt",  -- 10^2259
    "TSxgSpt",  -- 10^2262
    "QaSxgSpt", -- 10^2265
    "QiSxgSpt", -- 10^2268
    "SxSxgSpt", -- 10^2271
    "SpSxgSpt", -- 10^2274
    "OcSxgSpt", -- 10^2277
    "NnSxgSpt", -- 10^2280,

    -- Septuagintiseptingentillion (10^2283-10^2310)
    "SpgSpt",   -- 10^2283
    "USpgSpt",  -- 10^2286
    "DSpgSpt",  -- 10^2289
    "TSpgSpt",  -- 10^2292
    "QaSpgSpt", -- 10^2295
    "QiSpgSpt", -- 10^2298
    "SxSpgSpt", -- 10^2301
    "SpSpgSpt", -- 10^2304
    "OcSpgSpt", -- 10^2307
    "NnSpgSpt", -- 10^2310,

    -- Octogintiseptingentillion (10^2313-10^2340)
    "OcgSpt",   -- 10^2313
    "UOcgSpt",  -- 10^2316
    "DOcgSpt",  -- 10^2319
    "TOcgSpt",  -- 10^2322
    "QaOcgSpt", -- 10^2325
    "QiOcgSpt", -- 10^2328
    "SxOcgSpt", -- 10^2331
    "SpOcgSpt", -- 10^2334
    "OcOcgSpt", -- 10^2337
    "NnOcgSpt", -- 10^2340,

    -- Nonagintiseptingentillion (10^2343-10^2370)
    "NogSpt",   -- 10^2343
    "UNogSpt",  -- 10^2346
    "DNogSpt",  -- 10^2349
    "TNogSpt",  -- 10^2352
    "QaNogSpt", -- 10^2355
    "QiNogSpt", -- 10^2358
    "SxNogSpt", -- 10^2361
    "SpNogSpt", -- 10^2364
    "OcNogSpt", -- 10^2367
    "NnNogSpt", -- 10^2370,

    -- Centiseptingentillion (10^2373-10^2400)
    "CeSpt",    -- 10^2373
    "UCeSpt",   -- 10^2376
    "DCeSpt",   -- 10^2379
    "TCeSpt",   -- 10^2382
    "QaCeSpt",  -- 10^2385
    "QiCeSpt",  -- 10^2388
    "SxCeSpt",  -- 10^2391
    "SpCeSpt",  -- 10^2394
    "OcCeSpt",  -- 10^2397
    "NvCeSpt",  -- 10^2400,

    -- Octingentillion Group (10^2403-10^2430)
    "Octg",   -- 10^2403
    "UOctg",  -- 10^2406
    "DOctg",  -- 10^2409
    "TOctg",  -- 10^2412
    "QaOctg", -- 10^2415
    "QiOctg", -- 10^2418
    "SxOctg", -- 10^2421
    "SpOctg", -- 10^2424
    "OcOctg", -- 10^2427
    "NnOctg", -- 10^2430,

    -- Vigintioctingentillion (10^2433-10^2460)
    "ViOctg", -- 10^2433
    "UViOctg",-- 10^2436
    "DViOctg",-- 10^2439
    "TViOctg",-- 10^2442
    "QaViOctg",--10^2445
    "QiViOctg",--10^2448
    "SxViOctg",--10^2451
    "SpViOctg",--10^2454
    "OcViOctg",--10^2457
    "NnViOctg",--10^2460,

    -- Trigintioctingentillion Group (10^2463-10^2490)
    "TgOctg",    -- 10^2463 (Trigintioctingentillion)
    "UTgOctg",   -- 10^2466 (Untrigintioctingentillion)
    "DTgOctg",   -- 10^2469 (Duotrigintioctingentillion)
    "TTgOctg",   -- 10^2472 (Tretrigintioctingentillion)
    "QaTgOctg",  -- 10^2475 (Quattuortrigintioctingentillion)
    "QiTgOctg",  -- 10^2478 (Quintrigintioctingentillion)
    "SxTgOctg",  -- 10^2481 (Sextrigintioctingentillion)
    "SpTgOctg",  -- 10^2484 (Septentrigintioctingentillion)
    "OcTgOctg",  -- 10^2487 (Octotrigintioctingentillion)
    "NnTgOctg",  -- 10^2490 (Novemtrigintioctingentillion),

    -- Quadragintioctingentillion Group (10^2493-10^2520)
    "QagOctg",   -- 10^2493 (Quadragintioctingentillion)
    "UQagOctg",  -- 10^2496 (Unquadragintioctingentillion)
    "DQagOctg",  -- 10^2499 (Duoquadragintioctingentillion)
    "TQagOctg",  -- 10^2502 (Trequadragintioctingentillion)
    "QaQagOctg", -- 10^2505 (Quattuorquadragintioctingentillion)
    "QiQagOctg", -- 10^2508 (Quinquadragintioctingentillion)
    "SxQagOctg", -- 10^2511 (Sexquadragintioctingentillion)
    "SpQagOctg", -- 10^2514 (Septenquadragintioctingentillion)
    "OcQagOctg", -- 10^2517 (Octoquadragintioctingentillion)
    "NnQagOctg", -- 10^2520 (Novemquadragintioctingentillion),

    -- Quinquagintioctingentillion Group (10^2523-10^2550)
    "QigOctg",   -- 10^2523 (Quinquagintioctingentillion)
    "UQigOctg",  -- 10^2526 (Unquinquagintioctingentillion)
    "DQigOctg",  -- 10^2529 (Duoquinquagintioctingentillion)
    "TQigOctg",  -- 10^2532 (Trequinquagintioctingentillion)
    "QaQigOctg", -- 10^2535 (Quattuorquinquagintioctingentillion)
    "QiQigOctg", -- 10^2538 (Quinquinquagintioctingentillion)
    "SxQigOctg", -- 10^2541 (Sexquinquagintioctingentillion)
    "SpQigOctg", -- 10^2544 (Septenquinquagintioctingentillion)
    "OcQigOctg", -- 10^2547 (Octoquinquagintioctingentillion)
    "NnQigOctg", -- 10^2550 (Novemquinquagintioctingentillion),

    -- Sexagintioctingentillion Group (10^2553-10^2580)
    "SxgOctg",   -- 10^2553 (Sexagintioctingentillion)
    "USxgOctg",  -- 10^2556 (Unsexagintioctingentillion)
    "DSxgOctg",  -- 10^2559 (Duosexagintioctingentillion)
    "TSxgOctg",  -- 10^2562 (Tresexagintioctingentillion)
    "QaSxgOctg", -- 10^2565 (Quattuorsexagintioctingentillion)
    "QiSxgOctg", -- 10^2568 (Quinsexagintioctingentillion)
    "SxSxgOctg", -- 10^2571 (Sexsexagintioctingentillion)
    "SpSxgOctg", -- 10^2574 (Septensexagintioctingentillion)
    "OcSxgOctg", -- 10^2577 (Octosexagintioctingentillion)
    "NnSxgOctg", -- 10^2580 (Novemsexagintioctingentillion),

    -- Septuagintioctingentillion Group (10^2583-10^2610)
    "SpgOctg",   -- 10^2583 (Septuagintioctingentillion)
    "USpgOctg",  -- 10^2586 (Unseptuagintioctingentillion)
    "DSpgOctg",  -- 10^2589 (Duoseptuagintioctingentillion)
    "TSpgOctg",  -- 10^2592 (Treseptuagintioctingentillion)
    "QaSpgOctg", -- 10^2595 (Quattuorseptuagintioctingentillion)
    "QiSpgOctg", -- 10^2598 (Quinseptuagintioctingentillion)
    "SxSpgOctg", -- 10^2601 (Sexseptuagintioctingentillion)
    "SpSpgOctg", -- 10^2604 (Septenseptuagintioctingentillion)
    "OcSpgOctg", -- 10^2607 (Octoseptuagintioctingentillion)
    "NnSpgOctg", -- 10^2610 (Novemseptuagintioctingentillion),

    -- Octogintioctingentillion Group (10^2613-10^2640)
    "OcgOctg",   -- 10^2613 (Octogintioctingentillion)
    "UOcgOctg",  -- 10^2616 (Unoctogintioctingentillion)
    "DOcgOctg",  -- 10^2619 (Duooctogintioctingentillion)
    "TOcgOctg",  -- 10^2622 (Treoctogintioctingentillion)
    "QaOcgOctg", -- 10^2625 (Quattuoroctogintioctingentillion)
    "QiOcgOctg", -- 10^2628 (Quinoctogintioctingentillion)
    "SxOcgOctg", -- 10^2631 (Sexoctogintioctingentillion)
    "SpOcgOctg", -- 10^2634 (Septenoctogintioctingentillion)
    "OcOcgOctg", -- 10^2637 (Octooctogintioctingentillion)
    "NnOcgOctg", -- 10^2640 (Novemoctogintioctingentillion),

    -- Nonagintioctingentillion Group (10^2643-10^2670)
    "NogOctg",   -- 10^2643 (Nonagintioctingentillion)
    "UNogOctg",  -- 10^2646 (Unnonagintioctingentillion)
    "DNogOctg",  -- 10^2649 (Duononagintioctingentillion)
    "TNogOctg",  -- 10^2652 (Trenonagintioctingentillion)
    "QaNogOctg", -- 10^2655 (Quattuornonagintioctingentillion)
    "QiNogOctg", -- 10^2658 (Quinnonagintioctingentillion)
    "SxNogOctg", -- 10^2661 (Sexnonagintioctingentillion)
    "SpNogOctg", -- 10^2664 (Septennonagintioctingentillion)
    "OcNogOctg", -- 10^2667 (Octononagintioctingentillion)
    "NnNogOctg", -- 10^2670 (Novemnonagintioctingentillion),

    -- Centioctingentillion Group (10^2673-10^2700)
    "CeOctg",    -- 10^2673 (Centioctingentillion)
    "UCeOctg",   -- 10^2676 (Uncentioctingentillion)
    "DCeOctg",   -- 10^2679 (Duocentioctingentillion)
    "TCeOctg",   -- 10^2682 (Trescentioctingentillion)
    "QaCeOctg",  -- 10^2685 (Quattuorcentioctingentillion)
    "QiCeOctg",  -- 10^2688 (Quincentioctingentillion)
    "SxCeOctg",  -- 10^2691 (Sexcentioctingentillion)
    "SpCeOctg",  -- 10^2694 (Septencentioctingentillion)
    "OcCeOctg",  -- 10^2697 (Octocentioctingentillion)
    "NvCeOctg",  -- 10^2700 (Novemcentioctingentillion),
    
    -- Nongentillion Group (10^2703-10^2730)
    "NnG",     -- 10^2703 (Nongentillion)
    "UNnG",    -- 10^2706 (Unnongentillion)
    "DNnG",    -- 10^2709 (Duonongentillion)
    "TNnG",    -- 10^2712 (Trenongentillion)
    "QaNnG",   -- 10^2715 (Quattuornongentillion)
    "QiNnG",   -- 10^2718 (Quinnongentillion)
    "SxNnG",   -- 10^2721 (Sexnongentillion)
    "SpNnG",   -- 10^2724 (Septennongentillion)
    "OcNnG",   -- 10^2727 (Octonongentillion)
    "NnNnG",   -- 10^2730 (Novemnongentillion),

    -- Vigintinongentillion Group (10^2733-10^2760)
    "ViNnG",   -- 10^2733 (Vigintinongentillion)
    "UViNnG",  -- 10^2736 (Unvigintinongentillion)
    "DViNnG",  -- 10^2739 (Duovigintinongentillion)
    "TViNnG",  -- 10^2742 (Trevigintinongentillion)
    "QaViNnG", -- 10^2745 (Quattuorvigintinongentillion)
    "QiViNnG", -- 10^2748 (Quinvigintinongentillion)
    "SxViNnG", -- 10^2751 (Sexvigintinongentillion)
    "SpViNnG", -- 10^2754 (Septenvigintinongentillion)
    "OcViNnG", -- 10^2757 (Octovigintinongentillion)
    "NnViNnG", -- 10^2760 (Novemvigintinongentillion),

    -- Trigintinongentillion Group (10^2763-10^2790)
    "TgNnG",    -- 10^2763 (Trigintinongentillion)
    "UTgNnG",   -- 10^2766 (Untrigintinongentillion)
    "DTgNnG",   -- 10^2769 (Duotrigintinongentillion)
    "TTgNnG",   -- 10^2772 (Tretrigintinongentillion)
    "QaTgNnG",  -- 10^2775 (Quattuortrigintinongentillion)
    "QiTgNnG",  -- 10^2778 (Quintrigintinongentillion)
    "SxTgNnG",  -- 10^2781 (Sextrigintinongentillion)
    "SpTgNnG",  -- 10^2784 (Septentrigintinongentillion)
    "OcTgNnG",  -- 10^2787 (Octotrigintinongentillion)
    "NnTgNnG",  -- 10^2790 (Novemtrigintinongentillion),

    -- Quadragintinongentillion Group (10^2793-10^2820)
    "QagNnG",   -- 10^2793 (Quadragintinongentillion)
    "UQagNnG",  -- 10^2796 (Unquadragintinongentillion)
    "DQagNnG",  -- 10^2799 (Duoquadragintinongentillion)
    "TQagNnG",  -- 10^2802 (Trequadragintinongentillion)
    "QaQagNnG", -- 10^2805 (Quattuorquadragintinongentillion)
    "QiQagNnG", -- 10^2808 (Quinquadragintinongentillion)
    "SxQagNnG", -- 10^2811 (Sexquadragintinongentillion)
    "SpQagNnG", -- 10^2814 (Septenquadragintinongentillion)
    "OcQagNnG", -- 10^2817 (Octoquadragintinongentillion)
    "NnQagNnG", -- 10^2820 (Novemquadragintinongentillion),

    -- Quinquagintinongentillion Group (10^2823-10^2850)
    "QigNnG",   -- 10^2823 (Quinquagintinongentillion)
    "UQigNnG",  -- 10^2826 (Unquinquagintinongentillion)
    "DQigNnG",  -- 10^2829 (Duoquinquagintinongentillion)
    "TQigNnG",  -- 10^2832 (Trequinquagintinongentillion)
    "QaQigNnG", -- 10^2835 (Quattuorquinquagintinongentillion)
    "QiQigNnG", -- 10^2838 (Quinquinquagintinongentillion)
    "SxQigNnG", -- 10^2841 (Sexquinquagintinongentillion)
    "SpQigNnG", -- 10^2844 (Septenquinquagintinongentillion)
    "OcQigNnG", -- 10^2847 (Octoquinquagintinongentillion)
    "NnQigNnG", -- 10^2850 (Novemquinquagintinongentillion),

    -- Sexagintinongentillion Group (10^2853-10^2880)
    "SxgNnG",   -- 10^2853 (Sexagintinongentillion)
    "USxgNnG",  -- 10^2856 (Unsexagintinongentillion)
    "DSxgNnG",  -- 10^2859 (Duosexagintinongentillion)
    "TSxgNnG",  -- 10^2862 (Tresexagintinongentillion)
    "QaSxgNnG", -- 10^2865 (Quattuorsexagintinongentillion)
    "QiSxgNnG", -- 10^2868 (Quinsexagintinongentillion)
    "SxSxgNnG", -- 10^2871 (Sexsexagintinongentillion)
    "SpSxgNnG", -- 10^2874 (Septensexagintinongentillion)
    "OcSxgNnG", -- 10^2877 (Octosexagintinongentillion)
    "NnSxgNnG", -- 10^2880 (Novemsexagintinongentillion),

    -- Septuagintinongentillion Group (10^2883-10^2910)
    "SpgNnG",   -- 10^2883 (Septuagintinongentillion)
    "USpgNnG",  -- 10^2886 (Unseptuagintinongentillion)
    "DSpgNnG",  -- 10^2889 (Duoseptuagintinongentillion)
    "TSpgNnG",  -- 10^2892 (Treseptuagintinongentillion)
    "QaSpgNnG", -- 10^2895 (Quattuorseptuagintinongentillion)
    "QiSpgNnG", -- 10^2898 (Quinseptuagintinongentillion)
    "SxSpgNnG", -- 10^2901 (Sexseptuagintinongentillion)
    "SpSpgNnG", -- 10^2904 (Septenseptuagintinongentillion)
    "OcSpgNnG", -- 10^2907 (Octoseptuagintinongentillion)
    "NnSpgNnG", -- 10^2910 (Novemseptuagintinongentillion),

    -- Octogintinongentillion Group (10^2913-10^2940)
    "OcgNnG",   -- 10^2913 (Octogintinongentillion)
    "UOcgNnG",  -- 10^2916 (Unoctogintinongentillion)
    "DOcgNnG",  -- 10^2919 (Duooctogintinongentillion)
    "TOcgNnG",  -- 10^2922 (Treoctogintinongentillion)
    "QaOcgNnG", -- 10^2925 (Quattuoroctogintinongentillion)
    "QiOcgNnG", -- 10^2928 (Quinoctogintinongentillion)
    "SxOcgNnG", -- 10^2931 (Sexoctogintinongentillion)
    "SpOcgNnG", -- 10^2934 (Septenoctogintinongentillion)
    "OcOcgNnG", -- 10^2937 (Octooctogintinongentillion)
    "NnOcgNnG", -- 10^2940 (Novemoctogintinongentillion),

    -- Nonagintinongentillion Group (10^2943-10^2970)
    "NogNnG",   -- 10^2943 (Nonagintinongentillion)
    "UNogNnG",  -- 10^2946 (Unnonagintinongentillion)
    "DNogNnG",  -- 10^2949 (Duononagintinongentillion)
    "TNogNnG",  -- 10^2952 (Trenonagintinongentillion)
    "QaNogNnG", -- 10^2955 (Quattuornonagintinongentillion)
    "QiNogNnG", -- 10^2958 (Quinnonagintinongentillion)
    "SxNogNnG", -- 10^2961 (Sexnonagintinongentillion)
    "SpNogNnG", -- 10^2964 (Septennonagintinongentillion)
    "OcNogNnG", -- 10^2967 (Octononagintinongentillion)
    "NnNogNnG", -- 10^2970 (Novemnonagintinongentillion),

    -- Centinongentillion Group (10^2973-10^3000)
    "CeNnG",    -- 10^2973 (Centinongentillion)
    "UCeNnG",   -- 10^2976 (Uncentinongentillion)
    "DCeNnG",   -- 10^2979 (Duocentinongentillion)
    "TCeNnG",   -- 10^2982 (Trescentinongentillion)
    "QaCeNnG",  -- 10^2985 (Quattuorcentinongentillion)
    "QiCeNnG",  -- 10^2988 (Quincentinongentillion)
    "SxCeNnG",  -- 10^2991 (Sexcentinongentillion)
    "SpCeNnG",  -- 10^2994 (Septencentinongentillion)
    "OcCeNnG",  -- 10^2997 (Octocentinongentillion)
    "NvCeNnG",  -- 10^3000 (Novemcentinongentillion),

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