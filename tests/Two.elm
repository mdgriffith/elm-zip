module Two exposing (suite)

import Bytes.Decode as Decode
import Bytes.Decode.Extra
import Bytes.Encode as Encode
import Bytes.Extra
import Dict
import Expect exposing (Expectation)
import Fuzz exposing (Fuzzer, int, list, string)
import Test exposing (..)
import ZipDecode


suite =
    describe "foo bar baz"
        [ test "file header" <|
            \_ ->
                let
                    file1 =
                        { header =
                            { versionToExtract = 10
                            , generalPurposeBitFlag = 0
                            , compressionMethod = 0
                            , lastModifiedTime = 37442
                            , lastModifiedDate = 20795
                            , crc32 = 143668611
                            , compressedSize = 12
                            , uncompressedSize = 12
                            , fileName = "test.txt"
                            , extraField = Bytes.Extra.empty
                            }
                        , compressedContent = Bytes.Extra.empty
                        }

                    file2 =
                        { header =
                            { versionToExtract = 10
                            , generalPurposeBitFlag = 0
                            , compressionMethod = 0
                            , lastModifiedTime = 34028
                            , lastModifiedDate = 20796
                            , crc32 = 950370240
                            , compressedSize = 12
                            , uncompressedSize = 12
                            , fileName = "lorum.txt"
                            , extraField = Bytes.Extra.empty
                            }
                        , compressedContent = Bytes.Extra.empty
                        }

                    central1 =
                        { versionMadeBy = 798
                        , versionToExtract = 10
                        , generalPurposeBitFlag = 0
                        , compressionMethod = 0
                        , lastModifiedTime = 37442
                        , lastModifiedDate = 20795
                        , crc32 = 143668611
                        , compressedSize = 12
                        , uncompressedSize = 12
                        , diskNumberStart = 0
                        , internalFileAttributes = 0
                        , externalFileAttributes = 2175008768
                        , relativeOffset = 0
                        , fileName = "test.txt"
                        , extraField = Bytes.Extra.empty
                        , fileComment = ""
                        }

                    central2 =
                        { versionMadeBy = 798
                        , versionToExtract = 10
                        , generalPurposeBitFlag = 0
                        , compressionMethod = 0
                        , lastModifiedTime = 34028
                        , lastModifiedDate = 20796
                        , crc32 = 950370240
                        , compressedSize = 12
                        , uncompressedSize = 12
                        , diskNumberStart = 0
                        , internalFileAttributes = 0
                        , externalFileAttributes = 2175008768
                        , relativeOffset = 78
                        , fileName = "lorum.txt"
                        , extraField = Bytes.Extra.empty
                        , fileComment = ""
                        }

                    end =
                        { diskNumber = 0
                        , diskNumberStart = 0
                        , diskEntries = 2
                        , totalEntries = 2
                        , size = 157
                        , offset = 157
                        , zipComment = ""
                        }

                    expected =
                        { possiblyCompressedFiles =
                            Dict.fromList
                                [ ( "test.txt", file1 )
                                , ( "lorum.txt", file2 )
                                ]
                        , uncompressedFiles = Dict.empty
                        , centrals = [ central1, central2 ]
                        , end = end
                        }
                in
                case ZipDecode.readZipFile bytes of
                    Just value ->
                        value
                            |> Expect.equal expected

                    Nothing ->
                        Debug.todo "failure"
        ]


bytes =
    rawBytes
        |> List.map Encode.unsignedInt8
        |> Encode.sequence
        |> Encode.encode


rawBytes =
    [ 0x50
    , 0x4B
    , 0x03
    , 0x04
    , 0x0A
    , 0x00
    , 0x00
    , 0x00
    , 0x00
    , 0x00
    , 0x42
    , 0x92
    , 0x3B
    , 0x51
    , 0x83
    , 0x35
    , 0x90
    , 0x08
    , 0x0C
    , 0x00
    , 0x00
    , 0x00
    , 0x0C
    , 0x00
    , 0x00
    , 0x00
    , 0x08
    , 0x00
    , 0x1C
    , 0x00
    , 0x74
    , 0x65
    , 0x73
    , 0x74
    , 0x2E
    , 0x74
    , 0x78
    , 0x74
    , 0x55
    , 0x54
    , 0x09
    , 0x00
    , 0x03
    , 0x3C
    , 0xBB
    , 0x70
    , 0x5F
    , 0x41
    , 0xBB
    , 0x70
    , 0x5F
    , 0x75
    , 0x78
    , 0x0B
    , 0x00
    , 0x01
    , 0x04
    , 0xE8
    , 0x03
    , 0x00
    , 0x00
    , 0x04
    , 0xE8
    , 0x03
    , 0x00
    , 0x00
    , 0x66
    , 0x6F
    , 0x6F
    , 0x20
    , 0x62
    , 0x61
    , 0x72
    , 0x20
    , 0x62
    , 0x61
    , 0x7A
    , 0x0A
    , 0x50
    , 0x4B
    , 0x03
    , 0x04
    , 0x0A
    , 0x00
    , 0x00
    , 0x00
    , 0x00
    , 0x00
    , 0xEC
    , 0x84
    , 0x3C
    , 0x51
    , 0xC0
    , 0x7F
    , 0xA5
    , 0x38
    , 0x0C
    , 0x00
    , 0x00
    , 0x00
    , 0x0C
    , 0x00
    , 0x00
    , 0x00
    , 0x09
    , 0x00
    , 0x1C
    , 0x00
    , 0x6C
    , 0x6F
    , 0x72
    , 0x75
    , 0x6D
    , 0x2E
    , 0x74
    , 0x78
    , 0x74
    , 0x55
    , 0x54
    , 0x09
    , 0x00
    , 0x03
    , 0x9C
    , 0xF5
    , 0x71
    , 0x5F
    , 0x9C
    , 0xF5
    , 0x71
    , 0x5F
    , 0x75
    , 0x78
    , 0x0B
    , 0x00
    , 0x01
    , 0x04
    , 0xE8
    , 0x03
    , 0x00
    , 0x00
    , 0x04
    , 0xE8
    , 0x03
    , 0x00
    , 0x00
    , 0x6C
    , 0x6F
    , 0x72
    , 0x65
    , 0x6D
    , 0x20
    , 0x69
    , 0x70
    , 0x73
    , 0x75
    , 0x6D
    , 0x0A
    , 0x50
    , 0x4B
    , 0x01
    , 0x02
    , 0x1E
    , 0x03
    , 0x0A
    , 0x00
    , 0x00
    , 0x00
    , 0x00
    , 0x00
    , 0x42
    , 0x92
    , 0x3B
    , 0x51
    , 0x83
    , 0x35
    , 0x90
    , 0x08
    , 0x0C
    , 0x00
    , 0x00
    , 0x00
    , 0x0C
    , 0x00
    , 0x00
    , 0x00
    , 0x08
    , 0x00
    , 0x18
    , 0x00
    , 0x00
    , 0x00
    , 0x00
    , 0x00
    , 0x00
    , 0x00
    , 0x00
    , 0x00
    , 0xA4
    , 0x81
    , 0x00
    , 0x00
    , 0x00
    , 0x00
    , 0x74
    , 0x65
    , 0x73
    , 0x74
    , 0x2E
    , 0x74
    , 0x78
    , 0x74
    , 0x55
    , 0x54
    , 0x05
    , 0x00
    , 0x03
    , 0x3C
    , 0xBB
    , 0x70
    , 0x5F
    , 0x75
    , 0x78
    , 0x0B
    , 0x00
    , 0x01
    , 0x04
    , 0xE8
    , 0x03
    , 0x00
    , 0x00
    , 0x04
    , 0xE8
    , 0x03
    , 0x00
    , 0x00
    , 0x50
    , 0x4B
    , 0x01
    , 0x02
    , 0x1E
    , 0x03
    , 0x0A
    , 0x00
    , 0x00
    , 0x00
    , 0x00
    , 0x00
    , 0xEC
    , 0x84
    , 0x3C
    , 0x51
    , 0xC0
    , 0x7F
    , 0xA5
    , 0x38
    , 0x0C
    , 0x00
    , 0x00
    , 0x00
    , 0x0C
    , 0x00
    , 0x00
    , 0x00
    , 0x09
    , 0x00
    , 0x18
    , 0x00
    , 0x00
    , 0x00
    , 0x00
    , 0x00
    , 0x00
    , 0x00
    , 0x00
    , 0x00
    , 0xA4
    , 0x81
    , 0x4E
    , 0x00
    , 0x00
    , 0x00
    , 0x6C
    , 0x6F
    , 0x72
    , 0x75
    , 0x6D
    , 0x2E
    , 0x74
    , 0x78
    , 0x74
    , 0x55
    , 0x54
    , 0x05
    , 0x00
    , 0x03
    , 0x9C
    , 0xF5
    , 0x71
    , 0x5F
    , 0x75
    , 0x78
    , 0x0B
    , 0x00
    , 0x01
    , 0x04
    , 0xE8
    , 0x03
    , 0x00
    , 0x00
    , 0x04
    , 0xE8
    , 0x03
    , 0x00
    , 0x00
    , 0x50
    , 0x4B
    , 0x05
    , 0x06
    , 0x00
    , 0x00
    , 0x00
    , 0x00
    , 0x02
    , 0x00
    , 0x02
    , 0x00
    , 0x9D
    , 0x00
    , 0x00
    , 0x00
    , 0x9D
    , 0x00
    , 0x00
    , 0x00
    , 0x00
    , 0x00
    ]
