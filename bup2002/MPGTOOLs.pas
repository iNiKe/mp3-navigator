unit MPGTools;
{

  MPEG AUDIO TOOLS
  (c) 1998, 1999 Copyright by Predrag Supurovic
  Edit (c) 2001 D.J. NiKe

  This library gives you tools for manipulating MPEG AUDIO files
  (*.mpa;*.mp2;*.mp3). It allows very easy reading and writing of MPEG
  data (TAG and HEADER).

  Supported formats are MPEG Versions 1, 2 and 2.5, Layer I, II and III, VBR.
  MPEG TAGs are also supported: ID3 v1.x, ID3 v2.x, DIDTAG.

  Compiled and tested with Delphi 1 and Delphi 3. Received reports
  that it sucessfully compiles with Delphi 4.
  Compiled & tested by D.J. NiKe with Delphi 5.

  If you are interested in MPEG file structure take a look at
  http://www.dv.co.yu/mpgscript/mpeghdr.htm.

  Updated info, new versions, supporting documentation and demo
  applications in source code are available at
  http://www.dv.co.yu/mpgscript/mpgtools.htm.


Author:
Predrag Supurovic
Dimitrija Tucovica 44/84
31000 Uzice
YUGOSLAVIA

Author's personal homepage: http://www.dv.co.yu/broker/
}


  INTERFACE

{$DEFINE UseDialogs}

uses SysUtils, WinTypes, WinProcs, Classes, Messages, Controls,
     {$IFDEF UseDialogs}Dialogs, {$ENDIF}INIFiles, Math, IO;

const
  UnitVersion = '2.0.NKS';   { current version of this unit }

  MaxGenres = 147;        { number of supported Genre codes.
                           If code is greater it will be assumed unknown }
  MaxAddGenres = 6;

  DefID3v2Padding = 1825;
  OptBegMPEG : boolean = false;
  Notag = '[notag]';

var Genres : array[0..MaxGenres] of string;
    AddGenres : array[0..MaxAddGenres] of string;
    HandleErrors : boolean = true;
    ID3v2Padding : integer = DefID3v2Padding;

const
  { MPEG version indexes }
  MPEG_VERSION_UNKNOWN = 0; { Unknown     }
  MPEG_VERSION_1 = 1;       { Version 1   }
  MPEG_VERSION_2 = 2;       { Version 2   }
  MPEG_VERSION_25 = 3;      { Version 2.5 }

  { Description of MPEG version index }
  MPEG_VERSIONS : array[0..3] of string = ('Unknown', '1.0', '2.0', '2.5');

  { Channel mode (number of channels) in MPEG file }
  MPEG_MD_STEREO = 0;            { Stereo }
  MPEG_MD_JOINT_STEREO = 1;      { Stereo }
  MPEG_MD_DUAL_CHANNEL = 2;      { Stereo }
  MPEG_MD_MONO = 3;              { Mono   }

  { Description of number of channels }
  MPEG_MODES : array[0..3] of string = ('Stereo', 'Joint-Stereo',
                                        'Dual-Channel', 'Single-Channel');

  { Description of layer value }
  MPEG_LAYERS : array[0..3] of string = ('Unknown', 'I', 'II', 'III');

  {
    Sampling rates table.
    You can read mpeg sampling frequency as
    MPEG_SAMPLE_RATES[mpeg_version_index][samplerate_index]
  }
  MPEG_SAMPLE_RATES : array[1..3] of array[0..3] of word =
     { Version 1   }
    ((44100, 48000, 32000, 0),
     { Version 2   }
     (22050, 24000, 16000, 0),
     { Version 2.5 }
     (11025, 12000, 8000, 0));
  MPEG_MODE_EXT : array[1..3] of array[0..3] of byte =
  (( 4, 8,12,16),
   ( 4, 8,12,16),
   ( 0, 4, 8,16));

  {
    Predefined bitrate table.
    Right bitrate is MPEG_BIT_RATES[mpeg_version_index][layer][bitrate_index]
  }
  MPEG_EMPHASIS : array[0..3] of string = ('None','50/15 microseconds','Dunno','CITT j.17');
  MPEG_BIT_RATES : array[1..3] of array[1..3] of array[0..15] of word =
       { Version 1, Layer I     }
     (((0,32,64,96,128,160,192,224,256,288,320,352,384,416,448,0),
       { Version 1, Layer II    }
       (0,32,48,56, 64, 80, 96,112,128,160,192,224,256,320,384,0),
       { Version 1, Layer III   }
       (0,32,40,48, 56, 64, 80, 96,112,128,160,192,224,256,320,0)),
       { Version 2, Layer I     }
      ((0,32,48, 56, 64, 80, 96,112,128,144,160,176,192,224,256,0),
       { Version 2, Layer II    }
       (0, 8,16,24, 32, 40, 48, 56, 64, 80, 96, 112,128,144,160,0),
       { Version 2, Layer III   }
       (0, 8,16,24, 32, 40, 48, 56, 64, 80, 96, 112,128,144,160,0)),
       { Version 2.5, Layer I   }
      ((0,32,48, 56, 64, 80, 96,112,128,144,160,176,192,224,256,0),
       { Version 2.5, Layer II  }
       (0, 8,16,24, 32, 40, 48, 56, 64, 80, 96, 112,128,144,160,0),
       { Version 2.5, Layer III }
       (0, 8,16,24, 32, 40, 48, 56, 64, 80, 96, 112,128,144,160,0)));

  { File types that unit can recognize and read }
  FT_ERROR = -1;                 { Specified file does not exist,
                                   or error openning file }
  FT_UNKNOWN = 0;                { Unknown file type }
  FT_WINAMP_PLAYLIST = 1;        { WinAmp playlist (*.m3u) }
  FT_MPEG_AUDIO = 3;             { MPEG Audio (*.mp*) }
  FT_PLS_PLAYLIST = 4;           { PLS Playlist (*.pls) }
  FT_NKS_PLAYLIST = 5;           { NiKe's Playlist (*.pls) }

  { Global variable containing delimiter used to separate artist from title
    in file name }
  FILENAMEDATADELIMITER : char = '-';

  { Xing VBR header flags }
  XH_FRAMES_FLAG = 1;
  XH_BYTES_FLAG = 2;
  XH_TOC_FLAG = 4;
  XH_VBR_SCALE_FLAG = 8;

type
  { Xing VBR Header data structure }
  TxHeadData = record
    flags : Integer;     { from Xing header data }
    frames : Integer;    { total bit stream frames from Xing header data }
    bytes : Integer;     { total bit stream bytes from Xing header data }
    vbrscale : Integer; { encoded vbr scale from Xing header data }
  end;

  String3 = string[3];
  String4 = string[4];
  String30 = string[30];
  String20 = string[20];
  String79 = string[79];
  String255 = string[255];

  tID3v2Header = packed record {variable length fields}
    Hdr   : array[1..3] of char;
    maVer : byte;
    miVer : byte;
    Flags : byte;
    Size  : array[1..4] of byte;
  end;

  tID3v2Frame = packed record
    fID   : array [1..4] of char;
    Size  : array [1..4] of byte;
    Flags : array [1..2] of byte;
  end;

  tID3v2ExtHdr = packed record
    Size  : array[1..4] of byte;
    Flags : array[1..2] of byte;
    pSize : array[1..4] of byte;
  end;

  tID3v1 = record {variable length fields}
    isID3v1Tagged : boolean;
    Artist      : string;
    Title       : string;
    Album       : string;
    Year        : string[4];
    Comment     : string;
    Track       : byte;
    Genre       : byte;
  end;

  tID3v2 = record {variable length fields}
    isID3v2Tagged : boolean;
    Size        : longint;
    Compressed  : boolean;
    isExtHdr    : boolean;
    isExperim   : boolean;
    Unsync      : boolean;
    maVer,miVer : byte;
    Artist      : string;
    Title       : string;
    Album       : string;
    Year        : string[4];
    Genre       : string;
    Composer    : string;
    OrigArtist  : string;
    CopyRight   : string;
    stURL       : string;
    EncodedBy   : string;
    Comments    : string;
    Track       : string;
  end;

  tDIDHeader = packed record {variable length fields}
    Size : word;
    Hdr  : array[1..6] of char;
  end;

  { This TAG is added at the end of MPEG, but before ID3 }
  tDIDTag = record {variable length fields}
    IsDIDTagged : boolean;
    Size      : word;
    Artist    : string;
    Title     : string;
    Album     : string;
    Year      : string;{[4]}
    Genre     : string;
    EncodedBy : string;
    EncSoft   : string;
    Comment   : string;
  end;

  { Definition for structure of MPEG AUDIO DATA records. Do not use it
    directly. Use TMPEGDATA type instead. }
  TMPEGData1v3 = packed record

    ID3v1Tag  : tID3v1;
    ID3v2Tag  : tID3v2;
    DIDTag    : tDIDTag;

    Title   : String;   { Song title  }
    Artist  : String;   { Artist name }
    Album   : String;   { Album  }
    Year    : String;   { Year }
    Comment : String;   { Comment }
    Genre   : string;   { Genre code }
    Track   : string;     { Track number on Album }

    PlayOfs     : integer;   {Смещение от начала песни в секундах}
    PlayEndOfs  : integer;   {Кол-во секунд, убранных с конца песни}
    Duration    : word;      { Длительность в секундах }
    FileLength  : LongInt;   { File length }
    Version     : byte;      { MPEG audio version index (1 - Version 1,
                               2 - Version 2,  3 - Version 2.5,
                               0 - unknown }
    Layer : byte;            { Layer (1, 2, 3, 0 - unknown) }
    SampleRate : LongInt;    { Sampling rate in Hz}
    BitRate : LongInt;       { Bit Rate }
    BPM : word;              { bits per minute - for future use }
    Mode : byte;             { Number of channels (0 - Stereo,
                               1 - Joint-Stereo, 2 - Dual-channel,
                               3 - Single-Channel) }
    Copyright : Boolean;     { Copyrighted? }
    Original : Boolean;      { Original? }
    ErrorProtection : boolean; { Error protected? }
    Padding : Boolean;       { If frame is padded }
    mPrivate  : boolean;
    Bits : byte;
    Emphasis : byte; 
    FrameLength : Word;      { total frame size including CRC }
    CRC : word;              { 16 bit File CRC (without TAG).
                               Not implemented yet. }
    FileName : String255;    { MPEG audio file name }
    FileDateTime : LongInt;  { File last modification date and time in
                               DOS internal format }
    FileAttr : Word;         { File attributes }
    VolumeLabel : string20;  { Disk label }
    Selected : word;         { If this field's value is greater than
                               zero then file is selected. Value
                               determines order of selection. }
    Reserved : array[1..45] of byte; { for future use }
  end;

  { Current definition for MPEG AUDIO DATA structure. This type will
    point to newest record definition in case of future changes.

    MPEG AUDIO DATA is basic structure. It consists of data read from
    MPEG TAG and MPEG HEADER of MPEG AUDIO FILE. }
  PMPEGData = ^TMPEGData;
  TMPEGData = TMPEGData1v3;

type
  TOnReadError = function (const MPEGData : TMPEGData) : word;
  { function called when error occures while reading MPEG data from file.
    This function should show error to user and ask for Retry, Cancel,
    Ignore. User choice should be returned as function value (mrRetry,
    mrCancel, mrIgnore }

  TMPEGAudio = class (TObject)
    private
      FData : TMPEGData;
        { TMPEGData structure. Use it if you need direct access to whole
          record. Otherwise, use class properties to read and write
          specific fields }
      FFileDetectionPrecision : Integer;
      FUnknownArtist : string;
      FUnknownTitle : string;
      FAutoLoad : Boolean;
        { if true data will be automatically loaded by FSetFileName }
      FOnReadError : TOnReadError;
        { Read error event }
      FFirstValidFrameHeaderPosition : LongInt;
      FMacro : string;
        { This field contains macro definition }
      FText : string;
        { this field contains converted macros }
      FSearchDrives : byte;
      function FFileDateTime : TDateTime;
        { File date time in TDateTime type. Converted
          value of data.FileDateTime }
      procedure FSetMacro (MacroStr : string);
        { this method sets FMacro field and recalculates FText }
      procedure FSetFileName (inStr : string);
      function FGetFileName : string;
      {$IFNDEF VER80}
      function FGetFileNameShort : string;
      {$ENDIF}
      function FGetSearchExactFileName : string;
      function FGetIsValid : Boolean;
      function FReadData : Integer;
      procedure FSetArtist (inString : string);
      function  FGetArtist : string;
      procedure FSetTitle (inString : string);
      function  FGetTitle : string;
      procedure FSetAlbum (inString : string);
      procedure FSetYear (inString : string);
      procedure FSetComment (inString : string);
      procedure FSetVolumeLabel (inString : string20);
      procedure FSetGenre (G : string);
      procedure FSetTrack (inByte : string);
      procedure FSetSelected (inWord : word);

    public
      Playing : boolean;
      constructor Create; { create object }
      procedure ResetData; { resets Data field to zero values }
      property FileDetectionPrecision : Integer
        read FFileDetectionPrecision
        write FFileDetectionPrecision;
      property AutoLoad : Boolean read FAutoLoad write FAutoLoad;
        { If set to true setting FileName property will automatically
          load data from file. It is True by Default. If it is False you have to
          use LoadData method to actualy load data from file. }
      property IsValid: Boolean read FGetIsValid;
        { True if MPEG audio file is correct }
      function IsValidStr (const IsValidTrue, IsValidFalse : string) : string;
        { Returns input value according to Original field value. }
      property FirstValidFrameHeaderPosition : LongInt
               read FFirstValidFrameHeaderPosition;
        { Contains file position (in bytes) of the first valid frame
          header found. That means, data before this byte is not
          recognized as valid MPEG audio. It may be considered trashed
          or some other header data (WAV envelope, ID3v2 TAG or
          something like that). If value is equal or greater than
          FileLength then valid header is not found. But in that case,
          IsValid should return False anyway. }

      property Title : String
               read FGetTitle
               write FSetTitle;
      { song Title }
      property UnknownTitle : string
               read FUnknownTitle
               write FUnknownTitle;
     { Value that should be returned if Title field in tag is empty.
       By default it is empty string. }
      property Artist : String
               read FGetArtist
               write FSetArtist;
         { Artist name }
      property UnknownArtist : string read FUnknownArtist write FUnknownArtist;
         { Value that should be returned if Artist Name field in tag is empty.
           By default it is empty string. }
      property Album : String read FData.Album write FSetAlbum;
         { Album  }
      property Year : String read FData.Year write FSetYear;
         { Year }
      property Comment : String read FData.Comment write FSetComment;
         { Comment }
      property Genre : string read FData.Genre write FSetGenre;
         { Genre code }
      function GenreStr : string;
         { Genre description }
      Property Track : string read FData.Track write FSetTrack;
         { Track number on Album }
      property Duration : word read FData.Duration;
         { Song duration in seconds }
      function DurationTime : TDateTime;
         { Song duration time }
      property FileLength : LongInt read FData.FileLength;
         { File length }
      property Version : byte read FData.Version;
         { MPEG audio version index }
      function VersionStr : string;
          { MPEG audio version description }
      property Layer : byte read FData.Layer;
         { Layer (1 or 2. 0 - unknown) }
      function LayerStr : string;
         { Layer description }
      property SampleRate : LongInt read FData.SampleRate;
         { Sampling rate }
      property BitRate : LongInt read FData.BitRate;
         { Bit Rate }
      property FrameLength : Word read FData.FrameLength;
        { Total length of MPEG frame including CRC }
      property BPM : word read FData.BPM;
        { Bits per minute - for future use }
      property Mode : byte read FData.Mode;
        { Number of channels (0 - Stereo, 1 - Joint-Stereo,
          2 - Dual-channel, 3 - Single-Channel) }
      function ModeStr : string;
        { Channel mode description }
      property Copyright : Boolean read FData.Copyright;
        { Copyrighted? }
      function CopyrightStr (const CopyrightTrue,
                                   CopyrightFalse : string) : string;
        { Returns input value according to Copyright field value. }
      property Original : Boolean read FData.Original;
        { Original? }
      function OriginalStr (const OriginalTrue,
                                  OriginalFalse : string) : string;
        { Returns input value according to Original field value. }
      property ErrorProtection : boolean read FData.ErrorProtection;
        { Error protected? }
      function ErrorProtectionStr (const ErrorProtectionTrue,
                                         ErrorProtectionFalse : string)
                                         : string;
        { Returns input value according to ErrorProtection field value. }
      property Padding : Boolean read FData.Padding;
        { If frame size padded }
      property CRC : word read FData.CRC;
        { 16 bit File CRC (without TAG) }
      property File_Name : string read FGetFileName write FSetFileName;
        { MPEG audio file name. When set it automatically reads all
          other data from file }
      {$IFNDEF VER80}
      property FileNameShort : string read FGetFileNameShort;
        { Return MPEG audio file name in DOS 8+3 format. Read only.
          File must exists.}
      {$ENDIF}
      {$IFNDEF VER80}
      property SearchDrives : byte read FSearchDrives write FSearchDrives;
        { Bitwise selection of drives that may be used for obtaining
          value of SearchExactFileName. See Drive indicator constants.
          Default value is DI_ALL_DRIVES. }
      {$ENDIF}
      property SearchExactFileName : string
        read FGetSearchExactFileName;
        { Try to find where field is based on volume label info. This
          is good when files are moving from disk to disk, and especially
          if they are on removable media like CD-ROM. If volume label
          cannot be found, result is the same as FileName property}
      property LoadData : Integer read FReadData;
        { Reading this method will load data from file and return eror value.
          You may use it in any moment, but if AutoLoad property is False
          you must call it after setting FileName property to actually
          load data from file. See FReadData for Return values. }
      property OnReadError : TOnReadError
               read FOnReadError
               write FOnReadError;
        { user definable function that will be called when error
          occures while reading MPEG file. OnReadError should
          show dialog box explaining error to user and asking him
          to choose what to do by clicking Cancel, Retry or Ignore button.
          Return values must be accordingly: mrCancel, mrRetry or mrIgnore }
      property FileDateTime : TDateTime read FFileDateTime;
        { File last modification date and time }
      property FileAttr : Word read FData.FileAttr;
        { File attributes }
      property VolumeLabel : string20
               read FData.VolumeLabel
               write FSetVolumeLabel;
        { Disk label }
      property Selected : word read FData.Selected write FSetSelected;
        { If this fields value is greater than zero then file is
          selected. Value determines order of selection. }
      function SelectedStr (const SelectedTrue,
                                  SelectedFalse : string) : string;
        { Returns input value according to Selected field value. }
      property Data : TMPEGData read FData write FData;
        { returns MPEG AUDIO DATA record }
      function DataPtr : PMPEGData;
        { Returns pointer to MPEG AUDIO DATA record }
      function WriteTags : Integer;
        { Write TAG to file. Returns -1 if file does not exists,
          zero if successful and IOResult code if not successful }
      function RemoveID3v1Tag : Integer;
        { Remove ID3v1 TAG from file. Return result same as WriteTag }
      function RemoveID3v2Tag : integer;
        { Remove ID3v2 TAG from file. Return result same as WriteTag }
      function RemoveDIDTag : integer;
        { Remove DID TAG from file. Return result same as WriteTag }
      property Macro : string read FMacro write FSetMacro;
        { You can read defined macro string or set new one. Macro string
          may contain macros in string form explained before. Use this
          to convert macros if you do not need it to be changed often.
          Each time you change contents of this property it will
          automatically update contents of Text property. This should
          be used if you need to occasionally get converted macro but
          not to change macros. Actual conversion will be done for the
          first time you set macro string, and you may read it from
          TMPEGAudio.Text property several times. This may speed up
          your application if you use it instead of calling
          TMPEGAudio.Textilize method each time. }
      property Text : string read FText;
         { Whenever change occure in TMPEGAudio.Macro property or other
           writable object properties, this field will be updated with
           converted macros from Macro property. Text property will be
           changed only when real change occures, and class takes care
           of that. You just have to read value when you need it. }
      function Textilize (MacroStr : string) : string;
        { Replace macros with string values based on MPEG data. This
          forces macro conversion on each call. Avoid using it. Set
          Macro property instead and read Text property whenever you
          need converted data. }
  end; { class TMPEGAUDIO }


  { these are functions used to calculate macro values. You may use
    them directly if you want to gain more speed (macro parsing
    can be slow). Do not remember to trim results since they are zero
    padded}
  function IIFStr (inb : boolean; truestr, falsestr : String) : string;
  function PadLeft (InStr : String; OutLen : Integer; Fill : Char) : String;
  function PadRight (InStr : String; OutLen : Integer; Fill : Char) : String;
  function GetMPEGFileName (const MPEGAudio : TMPEGAudio) : string; far;
  function GetMPEGFilePath (const MPEGAudio : TMPEGAudio) : string; far;
  function GetMPEGVolumeLabel (const MPEGAudio : TMPEGAudio) : string; far;
  function GetMPEGTitle (const MPEGAudio : TMPEGAudio) : string; far;
  function GetMPEGTrack (const MPEGAudio : TMPEGAudio) : string; far;
  function GetMPEGExtractedArtist (const MPEGAudio : TMPEGAudio) : string; far;
  function GetMPEGExtractedTitle (const MPEGAudio : TMPEGAudio) : string; far;
  function GetMPEGFileDate (const MPEGAudio : TMPEGAudio) : string; far;
  function GetMPEGFileDateTimeforSort (const MPEGAudio : TMPEGAudio) : string; far;
  function GetMPEGFileTime (const MPEGAudio : TMPEGAudio) : string; far;
  function GetMPEGArtist (const MPEGAudio : TMPEGAudio) : string; far;
  function GetMPEGAlbum (const MPEGAudio : TMPEGAudio) : string; far;
  function GetMPEGYear (const MPEGAudio : TMPEGAudio) : string; far;
  function GetMPEGComment (const MPEGAudio : TMPEGAudio) : string; far;
  function GetMPEGGenre (const MPEGAudio : TMPEGAudio) : string; far;
  function GetMPEGDuration (const MPEGAudio : TMPEGAudio) : string; far;
  function GetMPEGDurationComma (const MPEGAudio : TMPEGAudio) : string; far;
  function GetMPEGDurationMinutes (const MPEGAudio : TMPEGAudio) : string; far;
  function GetMPEGDurationMinutesComma (const MPEGAudio : TMPEGAudio) : string; far;
  function GetMPEGDurationForm (const MPEGAudio : TMPEGAudio) : string; far;
  function GetMPEGLength (const MPEGAudio : TMPEGAudio) : string; far;
  function GetMPEGLengthComma (const MPEGAudio : TMPEGAudio) : string; far;
  function GetMPEGLengthKB (const MPEGAudio : TMPEGAudio) : string; far;
  function GetMPEGLengthKBComma (const MPEGAudio : TMPEGAudio) : string; far;
  function GetMPEGLengthMB (const MPEGAudio : TMPEGAudio) : string; far;
  function GetMPEGVersion (const MPEGAudio : TMPEGAudio) : string; far;
  function GetMPEGLayer (const MPEGAudio : TMPEGAudio) : string; far;
  function GetMPEGLayerNr (const MPEGAudio : TMPEGAudio) : string; far;
  function GetMPEGSampleRate (const MPEGAudio : TMPEGAudio) : string; far;
  function GetMPEGSampleRateKHz (const MPEGAudio : TMPEGAudio) : string; far;
  function GetMPEGBitRate (const MPEGAudio : TMPEGAudio) : string; far;
  function GetMPEGErrorProt (const MPEGAudio : TMPEGAudio) : string; far;
  function GetMPEGErrorProtA (const MPEGAudio : TMPEGAudio) : string; far;
  function GetMPEGCopyright (const MPEGAudio : TMPEGAudio) : string; far;
  function GetMPEGCopyrightA (const MPEGAudio : TMPEGAudio) : string; far;
  function GetMPEGOriginal (const MPEGAudio : TMPEGAudio) : string; far;
  function GetMPEGOriginalA (const MPEGAudio : TMPEGAudio) : string; far;
  function GetMPEGMode (const MPEGAudio : TMPEGAudio) : string; far;
  function GetMPEGStereo (const MPEGAudio : TMPEGAudio) : string; far;
  function GetProgramVersion : string; far;
  function GetCurrentSystemDate : string; far;
  function GetCurrentSystemTime : string; far;

type
  { User defined function of TShowProgressFunc type may be used by unit
    to show progress of reading files. TagData is value of current MPEG
    DATA record.  Function may read any info from it. ListName is name
    of list. Counter shows current count of processed files, and
    MaxCount is number of files that will be processed. Form that
    displays progess should have Cancel button. Funtion should return
    False if user canceled progressing.

    We suggest you not to use this function to actually display progress
    form, but to change values of already openned form.

    Since this function will be usually called from loop, which may have
    large number of iterations, unit will release some time to let
    Windows process system messages. If it does not work correctly (if
    you cannot click Cancel button for instance), it is advisable for
    you to put Application.ProcessMessages call in your function.
  }
  TShowProgressFunc = function (const TagData : TMPEGAudio;
                                const ListName : string;
                                Counter : Integer;
                                MaxCount : Integer) : Boolean;

  { User defined function of TShowProgressError type may be used by unit
    to show error while processing. FileName is name of file which
    processing failed. This function will be called only when trying to
    load data from file. If file is Winamplist or MPEG DataFile it will
    be called only when error ocurrs openning that file, not files inside
    of it.

    Form should be modal and have Cancel, Retry, Ignore buttons. Function
    should return Modal result of form closing.
  }
  TShowProgressErrorFunc = function (const FileName : string) : Word;

  { User defined function of TShowExportProgressFunc will be used by
    unit to show export progress. It is similar to TShowProgrsFunc but
    with less input parameters.
  }
  TShowExportProgressFunc = function (const TagData : TMPEGAudio;
                                            Counter : Integer) : Boolean;

  TMPEGProgressFunc = function (const TagData : TMPEGAudio;
                                            Counter : Integer) : Boolean;

  { User defined function for comparing sorted items in list has input
    pointers to two compared items and returns 0 if items are equal,
    >0 if Item1 > Item2 or <0 if Item1 < Item2. Here are two types, one
    function, and the other object method. }
  TListSortCompare = function (Item1, Item2: Pointer): Integer of object;
  TListSortCompareFunc = function (Item1, Item2: Pointer): Integer;

  { User defined function for showin sort progress }
  TShowSortProgressFunc = procedure (currItem : Integer);

  { TSortMethod type defines sorting method used for TMPEGAudioList.
    smNone - list isnot sorted
    smInternal - list is sorted by internal rules (Artist+Title);
    smUser - List is sorted by user funtction assigned to
             UserSortCompareFunc property }

  TSortMethod = (smNone,smInternal,smUser);


  TSortDirection = (srtAscending, srtDescending);

  { ShowSortBeginProc will be called prior to start of sort process.
    ShowSortEndProc will be called after sort process is finished.
    TMPEGAudioList.ShowSortProgressFunc will be called to show sort progress.
    }
  TShowSortBeginProc = procedure (StartValue, MaxValue: Integer);
  TShowSortEndProc = procedure;

(*
    %<tagid>[,<alignment>][,<length>][,<padchar>]%

    %This is title,C,70%

    ALIGNMENT

       L - left, no default length
       R - right, default length depends on tag
       C - centered, default length depends on tag
       T - trimmed, no default length

*)

 { this type determines which data type macro represents }
type
  TMacroDataType = (mctMPEGAudio,       { TMPEGAudio type must be passed }
                    mctNoExec,          { No function will be called even
                                          if assigned. This is used for macros
                                          handled internaly (newline, tab...)}
                    mctSpecial,         { No input parameters needed. Used
                                          mostly for system data, like current
                                          date and time }
                    mctMPEGReport,      { Data passed to function are
                                          calculated in report. Not implemented
                                          yet. }
                    mctComplexMacro);   { Data pased references other macros in
                                          string. This allows you to have single
                                          macro that conatins data of several
                                          other macros. Be careful. If you add
                                          macro in it's own definition, system will crash.
                                          This macro type does not work in Delphi 1.}

  TMacroDataSet = set of TMacroDataType;

  { this type contains definition for a single macro. Macros are organized
    in TMacroDefinition class based on TList }
  TMacro = class
    ShortName,                  { short name of macro }
    LongName : string;          { long name of macro }
    DefaultLength : Integer;    { default output string length }
    DefaultAlignment : char;    { default alignment of data }
    DefaultCapitalization : char; { default capitazlization of data }
    Description,                { description of macro (to be shown to users) }
    Cathegory : string;         { cathegory, group where macro belongs,
                                  for displaying purpose}
    MacroType : TMacroDataType; { type of data that should be passed to
                                  callback function }
    ValueProc : pointer;        { Pointer to callback function }
    CustomString : string;      { Custom string. For mctComplexMacro here should
                                  be complex macro definition }
  end;

  { These are definitions for macro resolving functions. }
  { TGetMPEGAudioValue function demands TMPEGAudio value as parameter
     and returns string value }
  TGetMPEGAudioValue = function (MPEGData : TMPEGAudio) : string;
  { TGetMPEGReportValue functions demands TMPEGReport value as parameter and
    returns string }
  { TGetSpecialt type function asks no parameters and returns string }
  TGetSpecialValue = function : string;

  { this is a list of all defined macros }
  TMacroDefinitions = class (Tlist)
    private
      FMacroDelimiterChar : char;
      function FGetMacroData (IndexNr : integer) : TMacro;
      function FCompareMacroItems (Item1, Item2: pointer): Integer;
    public
      constructor Create;
        { create object }
      destructor Free;
        { free object }
      function Add (ShortName,
                    LongName : string;
                    DefaultLength : Integer;
                    DefaultAlignment : char;
                    DefaultCapitalization : char;
                    Description,
                    Cathegory : string;
                    MacroType : TMacroDataType;
                    ValueProc : pointer;
                    CustomString : string) : Integer;
        { add new macro to the list. It asks for parameters to simplify
          macro adding procedure (it is much nicer if you have to call method
          and pass macro definition as parameters than create TMacro, then
          set it and add it to the list. If someone needs it it's easy to add
          AddMAcro method which wil dmenat onlu TMacro value as parameter }
      function Find (MacroName : string) : Integer;
        { Find Macro by name. You can use short or long name of macro. Name
          should not contain macro delimiters }
      property MacroDelimiterChar : char
        read fMacroDelimiterChar
        write fMacroDelimiterChar;
        { Character used to define bound for macro items. By default it is '%' }
      property Items[IndexNr : integer] : TMacro
        read FGetMacroData;
        { Access Macro definitions through array }
      function GetValue (MacroItem : string;
                         MPEGAudio : TMPEGAudio) : string;
        { Resolve single macro item. MacroItem must be complete
          macro including macro delimiters and optional parameters.
          Other two parameters are data which may bee needed to
          resolve macro. These parameters are nil, macros depending
          on them will not be resolved. and they will be returned
          unchanged in result string. }
      function Textilize (MacroStr : string;
                          MPEGAudio : TMPEGAudio) : string;
        { resolve several macros in single string. It will separate each macro
          item and call GetValue method to resolve it }
      procedure Sort;
        { sort macro list based on Compare procedure }
  end; { TMacroDefinitions }

  { delimiter used in CreateMacroDescriptionFile function }
  TMacroListDelimiter = (Tabs, Spaces);

var Macros : TMacroDefinitions;

{ public functions }

Function SecondsToTime (TimeSec : LongInt) : TDateTime;
  { Convert number of seconds to TDateTime value }

function GetGenreStr (Genre : Integer) : string;
  { Returns string description of Genre code }


const
  { drive indicators used for GetDriveName }
  DI_REMOVABLE = 1; { floppy }
  DI_FIXED = 2;     { hard }
  DI_REMOTE = 4;    { network }
  DI_CDROM = 8;     { cdrom }
  DI_RAMDISK = 16;   { ram disk }
  DI_ALL_DRIVES = DI_REMOVABLE + DI_FIXED + DI_REMOTE + DI_CDROM + DI_RAMDISK;
   { all drives }
  DI_ALL_BUT_FLOPPY = DI_FIXED + DI_REMOTE + DI_CDROM + DI_RAMDISK;
    { all drives except flopies }

{$IFNDEF VER80}
function GetDriveList : TStringlist;
 { Return list of drives found }

function GetDriveName (VolumeLabel : string; CheckDrives : byte) : string;
 { Returns drive name for volume label or empty string if drive
   with specified volume label is not found. Checkdrives is bitwise
   selection of drive types that should be checked. See drive indicators above. }
{$ENDIF}

function  ReadChar(var f : file; var ch : char) : integer;
function  PeekChar(var f : file; var ch : char) : integer;
function  ReadChar_UnSync(var f : file; var ch : char) : integer;
function  CalcSize28(s : array of byte) : integer;
procedure MakeSize28(s : integer; var b : array of byte);
function  GetFileType(FileName : string) : integer;
function  TimeSt(i : integer; ShowHr : boolean) : string;
function  LZ(i,n : integer; ch : char) : string;
function GetTrackNum(st : string) : integer;

var ProgressFunc : pointer{TMPEGProgressFunc};

  implementation uses Main;

{ local types definition }

type
  { Original structure of tag in MPEG AUDIO file. For internal use.
    You should use TMPEGDATA structure.}
  TID3v1Tag = packed record
    Header  : array[1..3] of char;      { If tag exists this must be 'TAG' }
    Title   : array[1..30] of char;      { Title data (PChar) }
    Artist  : array[1..30] of char;     { Artist data (PChar) }
    Album   : array[1..30] of char;      { Album data (PChar) }
    Year    : array[1..4] of char;        { Date data }
    Comment : array[1..30] of char;    { Comment data (PChar) }
    Genre   : byte;                      { Genre data }
  end;

  { Type for delimiters used in some string manipulating functions }
  Delimiter = set of Char;

const
  InterpunctionChars = [' ','.',',',';', ':', '<', '>',
                        '?', '/', '!', '(', ')'];


{************************************************************
 public functions
************************************************************}

function GetTrackNum(st : string) : integer;
var i,e : integer;
    s : string;
begin
  Result := -1;
  s := '';
  for i := 1 to length(st) do if not (st[i] in ['0'..'9']) then break else s := s + st[i];
  val(s,i,e);
  if e = 0 then Result := i;
end;

function LZ(i,n : integer; ch : char) : string;
begin
  Result := inttostr(i);
  while length(Result) < n do Result := ch+Result;
end;

function  TimeSt(i : integer; ShowHr : boolean) : string;
var t,l : integer;
begin
  Result := '';
  if ShowHr then
  begin
    t := i div (60*60);
    if t > 0 then
    begin
      i := i - t*(60*60);
      Result := inttostr(t) + ':';
      l := 2;
    end else l := 1;
  end else l := 1;
  Result := Result + lz(i div 60,l,'0') + ':' + lz(i mod 60,2,'0');
end;
{----------------------------------------------}
function  GetFileType(FileName : string) : integer;
var ext : string;
begin
  Result := FT_UNKNOWN;
  ext := uppercase(trim(ExtractFileExt(FileName)));
  if length(ext)>1 then if ext[1]='.' then
  begin
    ext := copy(ext,2,length(ext));
    if (ext = 'MP3')or(ext = 'MP2')or(ext = 'MPA')or(ext = 'MPGA')or(ext = 'MPEGA')or(ext = 'MP1') then
    begin
      Result := FT_MPEG_AUDIO;
(*
  FT_ERROR = -1;                 { Specified file does not exist,
*)
    end else
    if (ext = 'M3U') then Result := FT_WINAMP_PLAYLIST else
    if (ext = 'PLS') then Result := FT_PLS_PLAYLIST else
    if (ext = 'NKS') then Result := FT_NKS_PLAYLIST else
  end else Result := FT_ERROR;
end;
{----------------------------------------------}
function  CalcSize28(s : array of byte) : integer;
begin
  Result := s[3] and $7F;
  Result := Result + (s[2] and $7F) shl 7;
  Result := Result + (s[1] and $7F) shl 14;
  Result := Result + (s[0] and $7F) shl 28;
end;

procedure MakeSize28(s : integer; var b : array of byte);
begin
  b[3] := s and $7F;
  b[2] := (s shr 7) and $7F;
  b[1] := (s shr 14) and $7F;
  b[0] := (s shr 21) and $7F;
end;

function  ReadChar(var f : file; var ch : char) : integer;
begin
{$I-}
  BlockRead(f,ch,1);
  Result := IOResult
{$I+}
end;

function  PeekChar(var f : file; var ch : char) : integer;
var fp : integer;
begin
{$I-}
  fp := filepos(f);
  BlockRead(f,ch,1);
  Seek(f,fp);
  Result := IOResult;
{$I+}
end;

function  ReadChar_UnSync(var f : file; var ch : char) : integer;
var c : char;
begin
{$I-}
  Result := ReadChar(f,ch);
  if (ch = #$FF)and(Result = 0) then
  begin
    Result := PeekChar(f,c);
    if (Result = 0)and(c = #$00) then ReadChar(f,ch);
  end;
{$I+}
end;

Function SecondsToTime (timesec : LongInt) : TDateTime;
 { convert LongInt number of seconds to TDateTime }
var tmpHour : word;
    tmpMin : word;
    tmpSec : word;
begin
  tmpHour := timesec DIV (60*60);
  tmpMin := (timesec - (tmpHour * 60 * 60)) DIV 60;
  tmpSec := timesec - (tmpHour * 60 * 60) - (tmpMin * 60);
  SecondsToTime := EncodeTime (tmpHour, tmpMin, tmpSec,0);
end;

{----------------------------------------------}
function GetGenreStr (Genre : Integer) : string;
begin
  If Genre <= MaxGenres then
    Result := Genres[Genre]
  else
    Result := 'Unknown';
end;

{$IFNDEF VER80}
{----------------------------------------------}
function GetDriveList : TStringlist;
var
  DriveStrings : array[0..4*26+2] of Char;
  StringPtr : Pchar;
begin
  GetLogicalDriveStrings (SizeOf (DriveStrings), DriveStrings);
  StringPtr := DriveStrings;
  Result := TStringList.Create;
  Result.Clear;
  while StringPtr <> nil do begin
    Result.Add (StringPtr);
    Inc (StringPtr, StrLen (StringPtr) + 1);
    if (Byte (StringPtr[0]) = 0) then StringPtr := nil;
  end;
end;

{----------------------------------------------}
function GetDriveName (VolumeLabel : string; CheckDrives : byte) : string;
var
  Drives : TStringList;
  i : Integer;
  VolName : array[0..255] of Char;
  SerialNumber : DWord;
  MaxCLength : Dword;
  FileSysFlag : DWord;
  FileSysName : array[0..255] of char;
  DriveType : Integer;
begin
  Result := '';
  Drives := GetDriveList;
  for i := Drives.Count-1 downto 0 do begin
    DriveType := GetDriveType (PChar (@Drives.strings[i][1]));
    if (DriveType <> DRIVE_UNKNOWN) and
       (DriveType <> DRIVE_NO_ROOT_DIR)
    then begin
      if ((1 Shl (DriveType - 2)) and CheckDrives) <> 0 then begin
        VolName := '';
        GetVolumeInformation (PChar (@Drives.strings[i][1]), VolName,
          255, @SerialNumber, MaxCLength, FileSysFlag, FileSysName, 255);
        if VolName = VolumeLabel then begin
          Result := Drives.Strings[i];
          Break;
        end; { if }
      end; { if }
    end; { if }
  end; { for }
end; { function }
{$ENDIF}



{----------------------------------------------}
function Extract4b (InVal : pointer) : Integer;
var
  vala : ^byte;
begin
  vala := InVal;
  Result := vala^ shl 8;
  Inc (vala);
  Result := Result shl 8;
  Result := Result or vala^;
  Inc (vala);
  Result := Result shl 8;
  Result := Result or vala^;
  Inc (vala);
  Result := Result shl 8;
  Result := Result or vala^;
end;

{************************************************************
 private functions
************************************************************}

{----------------------------------------------}
Procedure winProcessMessages;
{ Allow Windows to process other system messages }
var
  ProcMsg  :  TMsg;
begin
  while PeekMessage(ProcMsg, 0, 0, 0, PM_REMOVE) do begin
    if (ProcMsg.Message = WM_QUIT) then Exit;
    TranslateMessage(ProcMsg);
    DispatchMessage(ProcMsg);
  end; { while }
end; { winProcessMessages }


{----------------------------------------------}
Function PosFirst (InStr, SubStr : String; StartPos : Integer) : Integer;
  { find firs position of SubStr in InStr begining from
    StartPos character. Return zero if SubStr not found. }
var
  Position : Integer;

Begin
  Delete (InStr,1,StartPos-1);
  Position := Pos (SubStr, InStr);
  If Position = 0 then Posfirst := 0 else PosFirst := StartPos + Position - 1;
End; { PosFirst }

{----------------------------------------------}
Function IIFStr (inb : boolean; truestr, falsestr : String) : string;
  { Return TrueStr or FalseStr regarding of value of inB }
  begin
    If Inb then
      IIFStr := TrueStr
    else
      IIFStr := FalseStr;
  end; { function IIFStr }

{----------------------------------------------}
Function IIFLong (inb : boolean; truev, falsev : LongInt) : longint;
  { Return TrueV or FalseV regardin of value of inB }
  begin
    If Inb then
      IIFLong := Truev
    else
      IIFLong := Falsev;
  end; { function IIFLong }

{----------------------------------------------}
Function TrimRight (InStr : string) : string;
  { Delete #32's and #0's from the end of InStr }
var
  i, StrLen : Byte;
begin
  StrLen := Length (instr);
  If StrLen > 0 then begin
    i := Pos (#0, InStr);
    If i > 0 then begin
      Delete (InStr, i, StrLen);
      StrLen := Length (InStr);
    end;
    i := StrLen;
    While (i > 0) and (instr [i] in [' ',#0]) do i := i - 1;
    Delete (instr, i + 1, StrLen);
  end; {if}
  TrimRight := instr;
end; { TrimRight }

{----------------------------------------------}
Function TrimLeft (instr : string) : string;
  { Delete #32's from the begining of InStr }
Var    i, StrLen : Byte;
Begin
  i := 1;
  StrLen := Length (instr);
  If StrLen > 0 then begin
    While (i <= StrLen) and (instr [i] = ' ') do Inc (i);
    Delete (instr, 1, i - 1);
  end; {if}
  TrimLeft := instr;
end; { TrimLeft }

{----------------------------------------------}
Function Trim (instr : string) : string;
  { Delete #32's from the begining of InStr and #32's and #0's
     from the end of InStr }
begin
  Trim := TrimLeft (TrimRight (instr) );
end;

{----------------------------------------------}
Function WordCount (InStr : string; Delimiters : Delimiter) : byte;
  { Count words in InStr. Words are delimited by Delimiters }
var
  i, drum, StrLen : Byte;
begin
  i := 1;
  drum := 0;
  StrLen := Length (instr);
  If (StrLen = 0) or ( (StrLen < 2) and (StrLen > 0) and
     (instr [1] in delimiters) ) then
  begin
    WordCount := 0;
    Exit;
  end; {if}
  While i < StrLen do begin
    If instr [i] in delimiters then Inc (drum);
    Inc (i);
  end; {while}
  WordCount := drum + 1;
end; { WordCount }

{----------------------------------------------}
Function WordGet (InStr : String; Wordnr : Integer;
                  Delimiters : Delimiter) : String;
  { Get word number WordNr from InStr. Words are delimited by Delimiters }
var
  i, drum, wordstart, wordend : Byte;
begin
  i := 1;
  drum := 0;
  wordstart := 1;
  wordend := Length (instr);

  If (wordnr < 1) or (WordCount (instr, Delimiters) < wordnr) then begin
    WordGet := '';
    Exit;
  end;

  While (drum < wordnr) and (i <= wordend) do begin
    If instr [i] in delimiters then begin
      Inc (drum);
      If drum = wordnr - 1 then wordstart := i + 1;
      If drum = wordnr then wordend := i - wordstart;
    end; {if}
    Inc (i);
  end; {while}
  WordGet := Copy (instr, wordstart, wordend);
end; { WordGet }

{----------------------------------------------}
Function Replicate (Fill :Char; Count : Integer) : String;
var
  I : Integer;
begin
  Result := '';
  for I := 1 to Count do Result := Result + Fill;
end;


{----------------------------------------------}
Function IsNumber (instr : String) : Boolean;
  { Check if string contains all numbers }
const
  cifre : set of char = ['0'..'9','.'];
var
  bTemp : Boolean;
  F : Integer;
begin
  bTemp := True;
  If Length (instr) > 0 then begin
    For F := 1 to Length (instr) do begin
      bTemp := bTemp and (InStr[F] in cifre);
      if not bTemp then break;
    end; { for }
  end else bTemp := False; { for }
  IsNumber := bTemp;
end; { isNumber }

{----------------------------------------------}
Function Left (InStr : String; OutLen : Integer) : String;
  { Return OutLen characters from the beginning of InStr.
    If InStr is shorter than OutLen, return whole InStr }
begin
  Left := Copy (instr, 1, outlen);
end; { Left }

{----------------------------------------------}
Function Right (InStr : String; OutLen : Integer) : String;
  { Return OutLen characters from the end of InStr.
    If InStr is shorter than OutLen, return whole InStr }
var
  StrLen : Integer;
begin
  StrLen := Length (instr);
  Right := Copy (instr, StrLen - outlen + 1, outlen);
end; { Right }

{----------------------------------------------}
Function PadLeft (InStr : String; OutLen : Integer; Fill : Char) : String;
begin
  Result := InStr;
  While Length(Result) < OutLen do Result := Result + Fill;
end; { PadLeft }

{----------------------------------------------}
Function PadRight (InStr : String; OutLen : Integer; Fill : Char) : String;
begin
  Result := InStr;
  While Length(Result) < OutLen do Result := Fill + Result;
end; { PadRight }

{----------------------------------------------}
Function PadCenter (InStr : String; OutLen : Integer; Fill : Char) : String;
begin
  Result := InStr;
  While Length(InStr) < OutLen do
   if Length(Result) mod 2 = 0 then Result := Result + Fill else Result := Fill + Result;
end; { PadCenter }

{----------------------------------------------}
Function Capitalize (InStr : String; Delimiters : Delimiter) : String;
var F : byte;
Begin
  For F := 1 to Length (InStr) do
  begin
    If F = 1 then InStr[F] := UpCase(InStr[F])
     else if InStr[F-1] IN Delimiters then InStr[F] := UpCase (InStr[F]);
  end; {for}
  Capitalize := InStr;
End;

{----------------------------------------------}
Function CapitalFirst (InStr : String) : String;
  { pocetno slovo prve reci u stringu konvertuje u veliko }
Begin
  If Length (InStr) = 0 Then Exit;
  Instr[1] := UpCase (Instr [1]);
  CapitalFirst := InStr;
End;


{----------------------------------------------}
function GetVolumeLabel(Drive: Char): String;
 { Function returns volume label of a disk. Works in all Delphi versions }
var
  SearchString: String[7];
  {$IFDEF VER80}
  SR: TSearchRec;
  P: Byte;
  {$ELSE}
  Buffer : array[0..255] of char;
  a,b : DWORD;
  {$ENDIF}
begin
  {$IFDEF VER80}
  SearchString := Drive + ':\*.*';
  { find vol label }
  if FindFirst(SearchString, faVolumeID, SR) = 0 then begin
    P := Pos('.', SR.Name);
    Result := SR.Name;
    { if it has a dot... }
    if P > 0 then Delete (Result, P, 1);
  end else Result := '';
  {$ELSE}
  SearchString := Drive + ':\' + #0;
  If GetVolumeInformation(@SearchString[1],buffer,sizeof(buffer),nil,a,b,nil,0) then
    Result := buffer
  else Result := '';
  {$ENDIF}
end;

{ QuickSort, used in TMOPEGAudioList and TMacroDefinitions }
procedure QuickSort(SortList: PPointerList; L, R: Integer;
                    var SortCompareFunc : TListSortCompare;
                    SortDirection : Integer;
                    ShowSortProgressFunc : TShowSortProgressFunc);
var
  I, J: Integer;
  P, T: Pointer;
begin
  repeat
    I := L;
    J := R;
    P := SortList^[(L + R) shr 1];
    repeat
      while (SortDirection * SortCompareFunc(SortList^[I], P) < 0) do Inc(I);
      while (SortDirection * SortCompareFunc(SortList^[J], P) > 0) do Dec(J);
      if I <= J then
      begin
        T := SortList^[I];
        SortList^[I] := SortList^[J];
        SortList^[J] := T;
        Inc(I);
        Dec(J);
      end;
    If @ShowSortProgressFunc <> nil then ShowSortProgressFunc (I);
    until I > J;
    if L < J then QuickSort(SortList, L, J, SortCompareFunc, SortDirection, ShowSortProgressFunc);
    L := I;
  until I >= R;
end; { QuickSort }


{----------------------------------------------}
function CalcFrameLength (Layer, SampleRate, BitRate : LongInt; Padding : Boolean) : Integer;
begin
  If SampleRate > 0 then
    if Layer = 1 then
      Result := Trunc (12 * BitRate * 1000 / SampleRate + (Integer (Padding)*4))
    else
      Result := Trunc (144 * BitRate * 1000 / SampleRate + Integer (Padding))
  else Result := 0;
end;

{----------------------------------------------}
function FrameHeaderValid (Data : TMPEGData) : Boolean;
begin
  Result := (Data.FileLength > 5) and
            (Data.Version > 0) and (Data.Version <=3) and
            (Data.Layer > 0) and (Data.Layer <= 3) and
            (Data.BitRate >= -1) and (Data.BitRate <> 0) and
            (Data.SampleRate > 0);
end;

{----------------------------------------------}
function DecodeHeader (MPEGHeader : array of byte; var MPEGData : TMpegData) : Boolean;
  { Decode MPEG Frame Header and store data to TMPEGData fields.
    Return True if header seems valid }
var BitrateIndex : byte;
    VersionIndex : byte;
begin
  MPEGData.Version := 0;
  MPEGData.Layer := 0;
  MPEGData.SampleRate := 0;
  MPEGData.Mode := 0;
  MPEGData.Copyright := False;
  MPEGData.Original := False;
  MPEGData.ErrorProtection := False;
  MPEGData.Padding := False;
  MPEGData.BitRate := 0;
  MPEGData.FrameLength := 0;
  if (MPEGHeader[0]=$FF)and(MPEGHeader[1] and $E0 = $E0) then
  begin
    VersionIndex := (MPEGHeader[1] and $18) shr 3;
    case VersionIndex of
      0 : MPEGData.Version := MPEG_VERSION_25;      { Version 2.5 }
      2 : MPEGData.Version := MPEG_VERSION_2;       { Version 2 }
      3 : MPEGData.Version := MPEG_VERSION_1;       { Version 1 }
      else MPEGData.Version := MPEG_VERSION_UNKNOWN; { Unknown }
    end;
    { if Version is known, read other data }
    MPEGData.Layer := 4 - (MPEGHeader[1] shr 1) and $3;
    BitrateIndex := (MPEGHeader[2] and $F0) shr 4;
    MPEGData.BitRate := MPEG_BIT_RATES[MPEGData.Version][MPEGData.Layer][BitrateIndex];
    MPEGData.SampleRate := MPEG_SAMPLE_RATES[MPEGData.Version][(MPEGHeader[2] shr 2) and $03];

    if FrameHeaderValid (MPEGData) then
    begin
      MPEGData.ErrorProtection := (MPEGHeader[1] and $01) = 1;
      if not MPEGData.ErrorProtection then MPEGData.CRC := (MPEGHeader[4] shl 8 + MPEGHeader[5]) else
       MPEGData.CRC := 0;
      MPEGData.mPrivate := (MPEGHeader[2] and $01) = 1;
      MPEGData.Padding := ((MPEGHeader[2] shr 1) and $1) = 1;
      MPEGData.Mode := ((MPEGHeader[3] shr 6) and $3);
      MPEGData.Bits := MPEG_MODE_EXT[MPEGData.Layer][((MPEGHeader[3] shr 4) and $3)];
      MPEGData.Copyright := ((MPEGHeader[3] shr 3) and $1) = 1;
      MPEGData.Original := ((MPEGHeader[3] shr 2) and $1) = 1;
      MPEGData.Emphasis := MPEGHeader[3] and $3; 

      If MPEGData.BitRate = 0 then MPEGData.Duration := 0
       else MPEGData.Duration := (MPEGData.FileLength*8) div (longint(MPEGData.Bitrate)*1000);
      MPEGData.FrameLength := CalcFrameLength (MPEGData.Layer, MPEGData.SampleRate, MPEGData.BitRate, MPEGData.Padding);

      Result:=true;
    end else Result:=false;
  end else Result := False;
end;


{************************************************************
default functions used for on error events
************************************************************}
{$IFDEF UseDialogs}
{ MPEGFileLoadEror is default for MPEGAudio.OnLoadError }
function MPEGFileLoadError (const MPEGData : TMPEGData) : word; far;
begin
  if HandleErrors then
  begin
    Result := MessageDlg ('Ошибка открытия файла: ' + MPEGData.FileName,
                           mtError, [mbCancel, mbRetry, mbIgnore], 0);
  end else Result := 0;
end;

{ OnShowProgressError is default for MPEGAudio.List.ShowProgressErrorFunc }
function OnShowProgressError (const FileName : string) : Word; far;
begin
  Result := MessageDlg ('Error opening file: ' + FileName,
                         mtError, [mbCancel, mbRetry, mbIgnore], 0);
end;
{$ENDIF}


{ methods }

{************************************************************
TMPEGAUDIO methods
************************************************************}

{----------------------------------------------}
constructor TMPEGAUDIO.Create;
begin
  inherited Create;
  FMacro := '';
  FText := '';
  FFirstValidFrameHeaderPosition := 0;
  FFileDetectionPrecision := 128000;
  {$IFDEF UseDialogs}
  FOnReadError := MPEGFileLoadError;
  {$ELSE}
  FOnReadError := nil;
  {$ENDIF}
  FAutoLoad := True;
  FUnknownArtist := 'Unknown Artist';
  FUnknownTitle := 'Unknown Title';
  FSearchDrives := DI_ALL_BUT_FLOPPY;
end;

{----------------------------------------------}
function TMPEGAUDIO.IsValidStr (const IsValidTrue, IsValidFalse : string) : string;
begin
  Result := IIFStr (IsValid, IsValidTrue, IsValidFalse);
end;

{----------------------------------------------}
function TMPEGAUDIO.DataPtr : PMpegData;
begin
  Result := @FData;
end;

{----------------------------------------------}
procedure TMPEGAUDIO.FSetFileName (inStr : string);
begin
  FData.FileName := inStr;
  If AutoLoad then FReadData;
end;

{----------------------------------------------}
function TMPEGAUDIO.FGetFileName : string;
begin
  Result := Data.FileName;
end;

{$IFNDEF VER80}
{----------------------------------------------}
function TMPEGAUDIO.FGetFileNameShort : string;
var
  path : string;
  sp : array[0..MAX_PATH] of char;
  err : integer;
begin
  path := Data.FileName + #0;
  err := GetShortPathName (PChar (path), sp, MAX_PATH);
  if err <> 0 then
    Result := string (sp)
  else
    Result := 'Error converting long filename to short.';
end;
{$ENDIF}


{----------------------------------------------}
function TMPEGAUDIO.FGetSearchExactFileName : string;
{$IFNDEF VER80}
var
  DriveName : string;
{$ENDIF}
begin
  Result := ExpandFileName (Data.FileName);
  {$IFNDEF VER80}
  if not FileExists (Result) then begin
    DriveName := GetDriveName (Data.VolumeLabel, SearchDrives);
    If DriveName <> '' then
      Result := DriveName + Copy (Result, Pos (':\', Result)+2, Length (Result));
  end;
  {$ENDIF}
end;


{----------------------------------------------}
function TMPEGAUDIO.FGetIsValid : Boolean;
begin
  Result := FrameHeaderValid (Data);
end;
{----------------------------------------------}
function TMPEGAUDIO.FFileDateTime : TDateTime;
begin
  if data.FileDateTime <> 0 then begin
   try
     Result := FileDateToDateTime (data.FileDateTime)
   except
     Result := 0;
   end;
  end else Result := 0;
end;


{----------------------------------------------}
procedure TMPEGAUDIO.ResetData;
{ Empty MPEG data }
begin
  with FData do
  begin
    Playing := false;
    ID3v1Tag.isID3v1Tagged := false;
    FillChar (Title, SizeOf (Title), #0);
    Title := NoTag;
    FillChar (Artist, SizeOf (Artist), #0);
    Artist := NoTag;
    FillChar (Album, SizeOf (Album), #0);
    Album := NoTag;
    Year := '    ';
    FillChar (Comment, SizeOf (Comment), #0);
    Comment := NoTag;
    Genre := '';
    Track := '';
    Duration := 0;
    FileLength := 0;
    Version := 0;
    Layer := 0;
    SampleRate := 0;
    Mode := 0;
    Copyright := False;
    Original := False;
    ErrorProtection := False;
    Padding := False;
    FrameLength := 0;
    BitRate := 0;
    BPM := 0;
    CRC := 0;
    FillChar (FileName, SizeOf (FData.FileName), #0);
    FileDateTime := 0;
    FileAttr := 0;
    FillChar (VolumeLabel, SizeOf (VolumeLabel), #0);
    Selected := 0;
    FillChar (Reserved, SizeOf (FData.Reserved), #0);
    with ID3v2Tag do
    begin
      isID3v2Tagged := false;
      Size          := 0;
      Compressed    := false;
      isExtHdr      := false;
      isExperim     := false;
      Unsync        := false;
      maVer         := 0;
      miVer         := 0;
      Artist        := NoTag;
      Title         := NoTag;
      Album         := NoTag;
      Year          := '';
      Genre         := NoTag;
      Composer      := NoTag;
      OrigArtist    := NoTag;
      CopyRight     := NoTag;
      stURL         := NoTag;
      EncodedBy     := NoTag;
      Comments      := NoTag;
    end;

  { This TAG is added at the end of MPEG, but before ID3 }
    with DIDTag do
    begin
      IsDIDTagged := false;
      Artist      := NoTag;
      Title       := NoTag;
      Album       := NoTag;
      Year        := '';
      Genre       := NoTag;
      EncSoft     := NoTag;
      EncodedBy   := NoTag;
      Comment     := NoTag;
    end;
    FText := Textilize (FMacro);
  end; { with }
end; { function }


{----------------------------------------------}
function TMPEGAUDIO.FReadData : Integer;
type MPEGHdr = array[1..6] of byte;
const BufSize = 2048;
var
  f : file;
  tag : TID3v1Tag;
  tagv2 : tID3v2Header;
  id3v2exthdr : tID3v2ExtHdr;
  id3v2frame  : tID3v2Frame;
  didtg : tDIDHeader;


  tempStr : string;

  mp3hdrread : array[1..6] of byte;
  tempLongInt : LongInt;
  Deviation : Integer;
  XingHeader : TXHeadData;
  XingData : array[1..116] of byte;
  XingDataP : ^byte;

  buf : array[0..BufSize] of byte;
  StartPos,BufPos,nr,i : integer;
  Found : boolean;
  e,ps,sz : integer;
  ts,s : string;
  ch : char;
  b,enc : byte;
  lng : packed array [1..3] of char;

function GetDSt(var s : string; l : byte) : boolean;
var ch : char;
    tb,i  : byte;
    sst : boolean;

begin
  if l=0 then blockread(f,tb,1) else tb:=l;
  s:=''; sst:=true;
  for i:=1 to tb do
  begin
    blockread(f,ch,1);
    if sst then
    begin
      if ch=#0 then sst:=false;
      s := s+ch;
    end;
  end;
  GetDSt:=true;
end;

begin
{$I-}
  tempStr := data.FileName;
  ResetData;
  FData.FileName := ExpandFileName (tempStr);

  repeat
    Result := -1;
    If FileExists (Data.Filename) then
    begin
      AssignFile (f, Data.Filename);

      FFirstValidFrameHeaderPosition := 0;
      FileMode := 0;
      try
        Reset (f,1);
        Result := IOResult;
        if (not FatalIOError(Result)) and (FileSize(f) > 5) then
        begin
          FData.FileDateTime := FileAge (Data.fileName);
          {FFileDateTime := FileDatetoDatetime (Data.FileDateTime);}
          FData.FileAttr := FileGetAttr (Data.FileName);
          FData.VolumeLabel := GetVolumeLabel (Data.FileName[1]);
          FData.FileLength := FileSize (f);
          fillchar(tagv2,sizeof(tagv2),#0);
          blockread(f,tagv2,sizeof(tagv2));
          if (Tagv2.Hdr = 'ID3')and(Tagv2.maVer < $10) then with fData.ID3v2Tag do
          begin
            Size := CalcSize28(Tagv2.Size);
            if (size > 10) then
            begin
              UnSync := Tagv2.Flags and $80 = $80;
              isExtHdr := Tagv2.Flags and $40 = $40;
              isExperim := Tagv2.Flags and $20 = $20;
              maVer := Tagv2.maVer;
              miVer := Tagv2.miVer;

              isID3v2Tagged := true;

              Artist        := '';
              Title         := '';
              Album         := '';
              Year          := '';
              Genre         := '';
              Composer      := '';
              OrigArtist    := '';
              CopyRight     := '';
              stURL         := '';
              EncodedBy     := '';
              Comments      := '';
              if isExtHdr then
              begin
                BlockRead(f,id3v2exthdr,sizeof(id3v2exthdr));
                sz := CalcSize28(id3v2exthdr.Size);
                Seek(f,sizeof(tID3v2Header) + sz);
              end;
              while filepos(f) <= Size + sizeof(sizeof(tID3v2Header)) do
              begin
                ps := filepos(f);
                BlockRead(f,id3v2Frame,sizeof(id3v2Frame));
//                sz := CalcSize28(id3v2Frame.Size);
                e := 8;
                sz := id3v2Frame.Size[4];
                for i := 3 downto 1 do
                begin
                  sz := sz + id3v2Frame.Size[i] shl e;
                  e := e + 8;
                end;
//                sz := longint(id3v2Frame.Size);
                if (sz < 0)or(sz > Size) then
                begin
                  sz := 0;
                end else
                if ((id3v2Frame.Flags[2] shr 7) and $1 = 0) and  // Compressed
                   ((id3v2Frame.Flags[2] shr 6) and $1 = 0) then // Encrypted
                begin
                  if id3v2Frame.fID[1] < #32 then break else
                  if id3v2Frame.fID[1] = 'T' then
                  begin
                    s:='';
                    BlockRead(f,enc,1);
                    nr:=1;
                    while nr < sz do
                    begin
                      BlockRead(f,ch,1);
                      if (FatalIOError(IOResult))or(eof(f)) then break;
                      if ch=#0 then break else s := s+ch;
                      inc(nr);
                    end;
                    if id3v2Frame.fID = 'TPE1' then Artist:= s else
                    if id3v2Frame.fID = 'TIT2' then Title := s else
                    if id3v2Frame.fID = 'TALB' then Album := s else
                    if id3v2Frame.fID = 'TENC' then EncodedBy := s else
                    if id3v2Frame.fID = 'TCOP' then CopyRight:= s else
                    if id3v2Frame.fID = 'TCOM' then Composer:= s else
                    if id3v2Frame.fID = 'TOPE' then OrigArtist:= s else
                    if id3v2Frame.fID = 'TRCK' then
                    begin
                      Track := s;
                    end else
                    if id3v2Frame.fID = 'TYER' then Year:= s else
                    if id3v2Frame.fID = 'TCON' then
                    begin
                      if length(s)>0 then
                      begin
                        if s[1] = '(' then
                        begin
                          b:=2;
                          ts:='';
                          while (b<=length(s))and(s[b] in ['0'..'9']) do
                          begin
                            ts := ts+s[b];
                            inc(b);
                          end;
                          if (b<=length(s))and(s[b]=')') then
                          begin
                            val(ts,i,e);
                            if (e=0)and(i<=MaxGenres) then
                            begin
                              ts := copy(s,b+1,length(s));
                              if Ansiuppercase(Genres[i]) = Ansiuppercase(ts) then delete(s,1,b);
                            end;
                          end;
                        end;
                      end;
                      Genre:= s;
                    end else
                  end else
                  if (id3v2Frame.fID = 'COMM') then
                  begin
                    s:='';
                    BlockRead(f,enc,1);
                    nr := 1;
                    BlockRead(f,lng,sizeof(lng));
                    inc(nr,sizeof(lng));
                    BlockRead(f,b,1);
                    inc(nr);
                    seek(f,filepos(f)+b);
                    while nr < sz do
                    begin
                      BlockRead(f,ch,1);
                      if (FatalIOError(IOResult))or(eof(f)) then break;
                      if ch=#0 then break else s := s+ch;
                      inc(nr);
                    end;
                    Comments := s;
                  end else
                  if (id3v2Frame.fID = 'WXXX') then
                  begin
                    s:='';
                    BlockRead(f,enc,1);
                    nr := 1;
                    BlockRead(f,b,1);
                    inc(nr);
                    seek(f,filepos(f) + b);
                    while nr < sz do
                    begin
                      BlockRead(f,ch,1);
                      if (FatalIOError(IOResult))or(eof(f)) then break;
                      if ch = #0 then break else s := s + ch;
                      inc(nr);
                    end;
                    stURL := s;
                  end;
                end;
                Seek(f,ps + sz + sizeof(tid3v2Frame));
              end;
{            id3v2frame}
            end;
          end;

          if fData.ID3v2Tag.isID3v2Tagged then seek(f,fData.ID3v2Tag.Size + sizeof(tagv2))
           else seek(f,0);
          StartPos := FilePos(f);
          bufpos := StartPos;
          repeat
            i:=0;
            Found := False; {Valid MPEG Header flag}
            while (not Found) and (not Eof (f)) do
            begin
              if FFileDetectionPrecision > 0 then if FilePos(f)-StartPos > FFileDetectionPrecision then break;
              Seek(f,bufpos);
              BlockRead (f, buf, sizeof(buf),nr);
              if FatalIOError(IOResult) then break;
              for i:=0 to (sizeof(buf) - (sizeof(buf) mod sizeof(MPEGHdr))) do
              begin
                if DecodeHeader(Buf[i],FData) then
                begin
                  Found:=true; break;
                end;
                if BufPos+i-StartPos > FFileDetectionPrecision then break;
              end;
              if not found then
              begin
                if nr <> sizeof(buf) then break;
                bufpos := bufpos + sizeof(buf) - (sizeof(buf) mod sizeof(MPEGHdr));
                if bufpos < 0 then bufpos := 0;
              end;

              { On each 200 bytes read, release procesor to allow OS do something else too }
{              If (FilePos (f) MOD 300) = 0 then winProcessMessages; {}
            end; { while }

            if Found then
            begin
              FFirstValidFrameHeaderPosition := BufPos + i;
              tempLongInt := FileLength - FirstValidFrameHeaderPosition - FrameLength + (2 * Byte(ErrorProtection));

              If (not IsValid) or (TempLongInt <= 0) then
              begin
                ResetData;
                FData.FileName := ExpandFileName (tempStr);
                FData.FileDateTime := FileAge (Data.fileName);
                FData.FileAttr := FileGetAttr (FData.FileName);
                FData.FileLength := FileSize (f);
                FFirstValidFrameHeaderPosition := FData.FileLength + 1;
                Result := -1;
              end else
              begin
                { Ok, one header is found, but that is not good proof that file realy
                  is MPEG Audio. But, if we look for the next header which must be
                  FrameLength bytes after first one, we may be very sure file is
                  valid. }
{
                Seek (f, FirstValidFrameHeaderPosition + FrameLength);
                BlockRead (f, mp3hdrread,sizeof(mp3hdrread));
}
                If {not DecodeHeader (mp3hdrread, FData)}false then
                begin
                  { well, next header is not valid. this is not MPEG audio file }
(*
                  ResetData;
                  FData.FileName := ExpandFileName (tempStr);
                  FData.FileDateTime := FileAge (FData.fileName);
                  {FFileDateTime := FileDatetoDatetime (Data.FileDateTime);}
                  FData.FileAttr := FileGetAttr (FData.FileName);
                  FData.FileLength := FileSize (f);
*)
                  { set file position back to the second byt of header that
                    seemed valid tolet function read all bytes that were
                    skipped inatempt tofind second header }
                  Seek (f, FirstValidFrameHeaderPosition + 1);
                  Result := -1;
                end else
                begin
                  { BINGO!!! This realy is MPEG audio file so we may proceed }
                  Result := 0;

                  { check for Xing Variable BitRate info }
                  if (FData.Version = 1) then
                  begin
                    if Fdata.Mode <> 3 then Deviation := 32 + 4
                     else Deviation := 17 + 4;
                  end else
                  begin
                    if Fdata.Mode <> 3 then Deviation := 17 + 4
                    else Deviation := 9 + 4;
                  end;
                  Seek (f, FirstValidFrameHeaderPosition + Deviation);
                  BlockRead (f, mp3hdrread,sizeof(mp3hdrread));

                  if (mp3hdrread[1] = Ord('X')) and
                     (mp3hdrread[2] = Ord ('i')) and
                     (mp3hdrread[3] = Ord ('n')) and
                     (mp3hdrread[4] = Ord ('g')) then
                  begin
                    Fdata.Bitrate := -1;
                    Seek (f, FirstValidFrameHeaderPosition + Deviation + 4);
                    BlockRead (f, XingData,SizeOf (XingData));
                    XingDataP := @XingData;
                    XingHeader.Flags := Extract4b (XingDataP);
                    Inc (XingDataP,4);
                    if (XingHeader.Flags and XH_FRAMES_FLAG) > 0 then
                    begin
                      XingHeader.frames := Extract4b (XingDataP);
                      Inc (XingDataP, 4);
                    end else XingHeader.frames := 0;
                    if (XingHeader.Flags and XH_BYTES_FLAG) > 0 then
                    begin
                      XingHeader.bytes := Extract4b (XingDataP);
                      Inc (XingDataP, 4);
                    end else XingHeader.bytes := 0;
                    if (XingHeader.Flags and XH_TOC_FLAG) > 0 then
                      Inc (XingDataP, 100);
                    if (XingHeader.Flags and XH_VBR_SCALE_FLAG) >0 then
                    begin
                      XingHeader.vbrscale := Extract4b (XingDataP);
                      {Inc (XingDataP, 4);}
                    end else XingHeader.vbrscale := 0;
                    fdata.Duration := Round ((1152 / fdata.samplerate) * xingHeader.frames);
                    if xingHeader.frames=0 then fdata.FrameLength := 0 else
                      fdata.FrameLength := fdata.fileLength div xingHeader.frames;
                  end;
                end; { if }
                { read TAG if it exists }
                if FData.FileLength > 128 then
                begin
                  Seek (f,FData.FileLength-sizeof(tag));
                  BlockRead(f, tag, sizeof(tag));
                  if tag.header='TAG' then
                  begin
                    FData.ID3v1Tag.isID3v1Tagged := true;

                    FData.ID3v1Tag.Title   := TrimRight (Tag.Title);
                    FData.ID3v1Tag.Artist  := TrimRight (Tag.Artist);
                    FData.ID3v1Tag.Album   := TrimRight (Tag.Album);
                    FData.ID3v1Tag.Year    := TrimRight (Tag.Year);
                    FData.ID3v1Tag.Comment := TrimRight (Tag.Comment);
                    FData.ID3v1Tag.Genre   := Tag.Genre;
                    if Tag.Comment[29] = #0 then FData.ID3v1Tag.Track := Ord (Tag.Comment[30])
                     else FData.ID3v1Tag.Track := 0;

                    Seek (f,FData.FileLength - sizeof(tag) - sizeof(didtg));
                  end else
                  begin
                    seek(f,FData.FileLength - sizeof(didtg));
                  end;

                  BlockRead(f, didtg, sizeof(didtg));
                  if (didtg.Hdr = 'ENDTAG')and(didtg.size<=1810) then
                  begin
                    fData.DIDTag.Size := didtg.size;
                    if FData.ID3v1Tag.isID3v1Tagged then seek(f,FileLength-sizeof(tag)-didtg.size-2)
                     else seek(f,FileLength-didtg.size-2);
                    BlockRead(f, didtg, sizeof(didtg));
                    if didtg.Hdr='DIDTAG' then
                    begin
                      fData.DIDTag.IsDIDTagged := true;
                      GetDSt(fData.DIDTag.Title,0);
                      GetDSt(fData.DIDTag.Artist,0);
                      GetDSt(fData.DIDTag.Album,0);
                      GetDSt(fData.DIDTag.Year,4);
                      GetDSt(fData.DIDTag.EncSoft,0);
                      GetDSt(fData.DIDTag.EncodedBy,0);
                      GetDSt(fData.DIDTag.Comment,0);
                      GetDSt(fData.DIDTag.Genre,0);
                    end;
                  end;

                  with FData do
                  begin
                    Title := '';
                    if (ID3v2Tag.isID3v2Tagged)and(ID3v2Tag.Title<>'') then Title := ID3v2Tag.Title else
                     if (DIDTag.isDIDTagged)and(DIDTag.Title<>'') then Title := DIDTag.Title else
                      if (ID3v1Tag.isID3v1Tagged) then Title := ID3v1Tag.Title;

                    Artist := '';
                    if (ID3v2Tag.isID3v2Tagged)and(ID3v2Tag.Artist<>'') then Artist := ID3v2Tag.Artist else
                     if (DIDTag.isDIDTagged)and(DIDTag.Artist<>'') then Artist := DIDTag.Artist else
                      if (ID3v1Tag.isID3v1Tagged) then Artist := ID3v1Tag.Artist;

                    Album := '';
                    if (ID3v2Tag.isID3v2Tagged)and(ID3v2Tag.Album<>'') then Album := ID3v2Tag.Album else
                     if (DIDTag.isDIDTagged)and(DIDTag.Album<>'') then Album := DIDTag.Album else
                      if (ID3v1Tag.isID3v1Tagged) then Album := ID3v1Tag.Album;

                    Year := '';
                    if (ID3v2Tag.isID3v2Tagged)and(ID3v2Tag.Year<>'') then Year := ID3v2Tag.Year else
                     if (DIDTag.isDIDTagged)and(DIDTag.Year<>'') then Year := DIDTag.Year else
                      if (ID3v1Tag.isID3v1Tagged) then Year := ID3v1Tag.Year;

                    Comment := '';
                    if (ID3v2Tag.isID3v2Tagged)and(ID3v2Tag.Comments<>'') then Comment := ID3v2Tag.Comments else
                     if (DIDTag.isDIDTagged)and(DIDTag.Comment<>'') then Comment := DIDTag.Comment else
                      if (ID3v1Tag.isID3v1Tagged) then Comment := ID3v1Tag.Comment;

                    Genre := '';
                    if (ID3v2Tag.isID3v2Tagged)and(ID3v2Tag.Genre<>'') then Genre := ID3v2Tag.Genre else
                     if (DIDTag.isDIDTagged)and(DIDTag.Genre<>'') then Genre := DIDTag.Genre else
                      if (ID3v1Tag.isID3v1Tagged) then
                      begin
                        if ID3v1Tag.Genre in [MaxGenres+1..255] then Genre := '' else Genre := Genres[ID3v1Tag.Genre];
                      end;

                    if (ID3v2Tag.isID3v2Tagged){and(ID3v2Tag.Track<>'')} then
                    begin
                      Track := ID3v2Tag.Track;
                    end else
                    begin
                      Track := inttostr(ID3v1Tag.Track);
                    end;
                  end;

                end; { if }
              end; { if }
            end;
            bufpos := bufpos + sizeof(buf) - (sizeof(buf) mod sizeof(MPEGHdr));
            if bufpos < 0 then bufpos := 0;
          until IsValid or Eof (f) or ((FilePos(f)-StartPos > FFileDetectionPrecision) and (FFileDetectionPrecision > 0));
          CloseFile(f);
          FText := Textilize (FMacro);
        end; { if }
      except
        Result := -1;
      end;
    end else {FData.Title := '[not found: ' + ExtractFileName (TempStr) + ']'};
    If (@FonReadError <> nil) and (Result <> 0) then
      Result := FOnReadError (data);
  until Result <> mrRetry;
{$I+}
end; { FReadData }

{----------------------------------------------}
function TMPEGAUDIO.WriteTags : Integer;
var f : file;
    newtag : TID3v1Tag;
    didhdr : TDIDHeader;
    tagv2 : TID3v2Header;
    isID3v1 : boolean;
    isID3v2 : boolean;
    didoem : packed array [1..6] of char;
    yr : packed array [1..4] of char;
    lng : packed array [1..3] of char;
    i,ps : integer;
    siz : word;
    l : byte;
    fsz,nsz,sk,nr,sz : integer;
    buf : packed array [0..32767] of byte;
    UnSync : boolean;
{    isExtHdr,isExperim : boolean; {}
    ch : char;
    frm : tID3v2Frame;
    ts,s : string;
    pr : real;

procedure ShowProgress(i : integer);
begin
  if ProgressFunc <> nil then TMPEGProgressFunc(ProgressFunc)(Self,i);
end;

begin
{$I-}
  Result := -1;
  ShowProgress(0);
  If FileExists (File_Name) then
  begin
    AssignFile (f, File_Name);
    FileMode := 2;
    Reset (f,1);
    Result := IOResult;
    if (not FatalIOError(Result)) then
    begin
      fsz := FileSize(f);
      if fsz <= 0 then exit; 
      Seek(f,0);
      FillChar(tagv2,sizeof(tagv2),#0);
      BlockRead(f,tagv2,sizeof(tagv2));
      UnSync := false;
      if (Tagv2.Hdr = 'ID3')and(Tagv2.maVer < $10) then
      begin
        sz := CalcSize28(Tagv2.Size) + sizeof(tagv2);
        UnSync := Tagv2.Flags and $7F = $7F;
{
        isExtHdr  := Tagv2.Flags and $BF = $BF;
        isExperim := Tagv2.Flags and $DF = $DF;
}
        isID3v2 := true;
      end else begin isID3v2 := false; sz := 0; end;

      if FData.ID3v2Tag.isID3v2Tagged then
      begin
        nsz := 128 + (4+4+2+1)*10 +
        length(FData.ID3v2Tag.Artist)+
        length(FData.ID3v2Tag.Title)+
        length(FData.ID3v2Tag.Album)+
        length(FData.ID3v2Tag.Year)+
        length(FData.ID3v2Tag.Genre)+
        length(FData.ID3v2Tag.Composer)+
        length(FData.ID3v2Tag.OrigArtist)+
        length(FData.ID3v2Tag.CopyRight)+
        length(FData.ID3v2Tag.EncodedBy)+
        (3+4+4+2+1+3+1+length(FData.ID3v2Tag.Comments)) + (3+4+4+2+1+1+Length(FData.ID3v2Tag.stURL));
        if isID3v2 then
        begin
          if sz >= nsz then
          begin
            if OptBegMPEG then
            begin
              if FFirstValidFrameHeaderPosition > nsz then sk := nsz - FFirstValidFrameHeaderPosition else sk := 0;
            end else
            begin
              nsz := sz;
              sk  := 0
            end;
          end else
          begin
            if OptBegMPEG then
            begin
              if FFirstValidFrameHeaderPosition > nsz then sk := nsz - FFirstValidFrameHeaderPosition else sk := 0;
            end else
            begin
              if nsz < ID3v2Padding then nsz := ID3v2Padding;
              sk := nsz - sz;
            end;
          end;
        end else
        begin
          if nsz < ID3v2Padding then nsz := ID3v2Padding;
          sk := nsz;
          if (OptBegMPEG)and(FFirstValidFrameHeaderPosition > sk)and(sk > 0) then sk := sk - FFirstValidFrameHeaderPosition;
        end;

        if (sk > 0) then
        begin
{          inc(sk,sizeof(tagv2));{}
          ps := fsz - sizeof(buf);
          if ps < 0 then ps := 0;
          repeat
            pr := (fsz - ps);
            if pr <= 0 then pr := 0 else pr := pr / fsz;
            ShowProgress(round(pr*100) - 1);
            Seek(f,ps);
            BlockRead(f,buf,sizeof(buf),nr);
            Seek(f,ps + sk);
            BlockWrite(f,buf,nr);
            ps := ps - sizeof(buf);
            if (FatalIOError(IOResult)) then Break;
          until ps <= 0;
          if ps < 0 then
          begin
            Seek(f,0);
            BlockRead(f,buf,sizeof(buf)+ps,nr);
            Seek(f,0 + sk);
            BlockWrite(f,buf,nr);
          end;
        end else if sk < 0 then
        begin
          sk := -sk;
          if (sk > 0) then
          begin
            ps := sk;
            Seek(f,ps);
            while (not eof(f)) do
            begin
              pr := (ps+sk) / fsz;
              ShowProgress(round((pr)*100) - 1);
              Seek(f,ps);
              BlockRead(f,buf,sizeof(buf),nr);
              Seek(f,ps - sk);
              BlockWrite(f,buf,nr);
              if (nr <> sizeof(buf))or(FatalIOError(IOResult)) then break;
              inc(ps,nr);
            end;
            Truncate(f);
          end;
        end;

        dec(nsz,sizeof(tagv2));
        Seek(f,0);
        tagv2.Hdr := 'ID3';
        tagv2.maVer := 3;
        tagv2.miVer := 0;
        tagv2.Flags := 0;
        MakeSize28(nsz,tagv2.size);
        BlockWrite(f,tagv2,sizeof(tagv2));
        l := 0; {Text Encoding}
        FillChar(frm,sizeof(frm),#0);

        frm.fID := 'TRCK';
        s := FData.ID3v2Tag.Track;
        MakeSize28(length(s) + 1,frm.Size);
        BlockWrite(f,frm,sizeof(frm));
        BlockWrite(f,l,1);
        for i := 1 to length(s) do begin BlockWrite(f,s[i],1); end;

        frm.fID := 'TENC';
        s := FData.ID3v2Tag.EncodedBy;
        MakeSize28(length(s) + 1,frm.Size);
        BlockWrite(f,frm,sizeof(frm));
        BlockWrite(f,l,1);
        for i := 1 to length(s) do begin BlockWrite(f,s[i],1); end;

        frm.fID := 'WXXX';
        s := FData.ID3v2Tag.stURL;
        MakeSize28(length(s) + 2,frm.Size);
        BlockWrite(f,frm,sizeof(frm));
        BlockWrite(f,l,1);
        ch := #0;
        BlockWrite(f,ch,1);
        for i := 1 to length(s) do begin BlockWrite(f,s[i],1); end;

        frm.fID := 'COMM';
        s := FData.ID3v2Tag.Comments;
        MakeSize28(length(s) + 2 + 3,frm.Size);
        BlockWrite(f,frm,sizeof(frm));
        ch := #0;
        BlockWrite(f,ch,1);
        BlockWrite(f,l,1);
        FillChar(lng,sizeof(lng),#0);
        BlockWrite(f,lng,sizeof(lng));
        for i := 1 to length(s) do begin BlockWrite(f,s[i],1); end;

        frm.fID := 'TCOM';
        s := FData.ID3v2Tag.Composer;
        MakeSize28(length(s) + 1,frm.Size);
        BlockWrite(f,frm,sizeof(frm));
        BlockWrite(f,l,1);
        for i := 1 to length(s) do begin BlockWrite(f,s[i],1); end;

        frm.fID := 'TCOP';
        s := FData.ID3v2Tag.CopyRight;
        MakeSize28(length(s) + 1,frm.Size);
        BlockWrite(f,frm,sizeof(frm));
        BlockWrite(f,l,1);
        for i := 1 to length(s) do begin BlockWrite(f,s[i],1); end;

        frm.fID := 'TOPE';
        s := FData.ID3v2Tag.OrigArtist;
        MakeSize28(length(s) + 1,frm.Size);
        BlockWrite(f,frm,sizeof(frm));
        BlockWrite(f,l,1);
        for i := 1 to length(s) do begin BlockWrite(f,s[i],1); end;

        frm.fID := 'TYER';
        s := FData.ID3v2Tag.Year;
        MakeSize28(length(s) + 1,frm.Size);
        BlockWrite(f,frm,sizeof(frm));
        BlockWrite(f,l,1);
        for i := 1 to length(s) do begin BlockWrite(f,s[i],1); end;

        frm.fID := 'TCON';
        s := FData.ID3v2Tag.Genre;
        MakeSize28(length(s) + 1,frm.Size);
        BlockWrite(f,frm,sizeof(frm));
        BlockWrite(f,l,1);
        for i := 1 to length(s) do begin BlockWrite(f,s[i],1); end;

        frm.fID := 'TALB';
        s := FData.ID3v2Tag.Album;
        MakeSize28(length(s) + 1,frm.Size);
        BlockWrite(f,frm,sizeof(frm));
        BlockWrite(f,l,1);
        for i := 1 to length(s) do begin BlockWrite(f,s[i],1); end;

        frm.fID := 'TPE1';
        s := FData.ID3v2Tag.Artist;
        MakeSize28(length(s) + 1,frm.Size);
        BlockWrite(f,frm,sizeof(frm));
        BlockWrite(f,l,1);
        for i := 1 to length(s) do begin BlockWrite(f,s[i],1); end;

        frm.fID := 'TIT2';
        s := FData.ID3v2Tag.Title;
        MakeSize28(length(s) + 1,frm.Size);
        BlockWrite(f,frm,sizeof(frm));
        BlockWrite(f,l,1);
        for i := 1 to length(s) do begin BlockWrite(f,s[i],1); end;

        frm.fID := 'T666';
        s := 'FileManager'; ts := appName + ' ' + appVer + ' © NiKe''Soft';
        MakeSize28(length(s) + length(ts) + 2+1,frm.Size);
        BlockWrite(f,frm,sizeof(frm));
        for i := 1 to length(s) do begin BlockWrite(f,s[i],1); end;
        ch := #0;
        BlockWrite(f,ch,1);
        BlockWrite(f,l,1);
        for i := 1 to length(ts) do begin BlockWrite(f,ts[i],1); end;

        nr := 0;
        ch := #0;

        while filepos(f) < nsz+sizeof(tagv2) do
        begin
          BlockWrite(f,ch,1); {zer0 fill}
          inc(nr);
          if isID3v2 then if nr > 10 then break;
        end;
      end else
      begin
        sk := 0;
        if isID3v2 then
        begin
          if not UnSync then sk := sz else
          begin
            sk := sizeof(tid3v2header);
            Seek(f,sk);
            while filepos(f) < sz do
            begin
              Result := ReadChar_UnSync(f,ch);
              if Result <> 0 then break;
            end;
            if Result = 0 then sk := filepos(f) else sk := 0;
          end;
        end;
        if (OptBegMPEG)and(FFirstValidFrameHeaderPosition > sk) then sk := FFirstValidFrameHeaderPosition;
        if (sk > 0) then
        begin
          ps := sk;
          Seek(f,ps);
          while (not eof(f)) do
          begin
            pr := (ps+sk) / fsz;
            ShowProgress(round((pr)*100) - 1);
            Seek(f,ps);
            BlockRead(f,buf,sizeof(buf),nr);
            Seek(f,ps - sk);
            BlockWrite(f,buf,nr);
            if (nr <> sizeof(buf))or(FatalIOError(IOResult)) then break;
            inc(ps,nr);
          end;
          Truncate(f);
        end;
      end;
      fsz := filesize(f);
      isID3v1 := false;
      if (fsz > sizeof(TID3v1Tag)) then
      begin
        Seek (f,fsz - sizeof(TID3v1Tag));
        BlockRead(f, newtag, sizeof(TID3v1Tag));
        if newtag.header = 'TAG' then isID3v1 := true;
      end;

      if isID3v1 then ps := fsz - sizeof(TID3v1Tag) - sizeof(didhdr)
        else ps := fsz - sizeof(didhdr);
      Seek (f,ps);
      BlockRead(f, didhdr, sizeof(didhdr));
{      Result := IOResult;}
      if (didhdr.Hdr = 'ENDTAG')and(didhdr.Size <= 1810) then
      begin
        if isID3v1 then ps := fsz - sizeof(tID3v1Tag) - didhdr.size - 2
          else ps := fsz - didhdr.size - 2;
         Seek (f,ps);
         BlockRead(f, didhdr, sizeof(didhdr));
         if didhdr.Hdr = 'DIDTAG' then
         begin
           ps := ps + 2;
         end else if isID3v1 then ps := fsz - sizeof(TID3v1Tag) else ps := fsz;
      end else
      begin
        if isID3v1 then ps := fsz - sizeof(TID3v1Tag)
          else ps := fsz;
      end;
      Seek(f, ps);
      if FData.DIDTag.isDIDTagged then
      begin
        didoem := 'DIDTAG';
        BlockWrite(f,didoem,sizeof(didoem));
        siz:=6;

        l := min(255,length(FData.DIDTag.Title));
        BlockWrite(f,l,1);
        for i:=1 to l do BlockWrite(f,FData.DIDTag.Title[i],1);
        inc(siz,l+1);

        l := min(255,length(FData.DIDTag.Artist));
        BlockWrite(f,l,1);
        for i:=1 to l do BlockWrite(f,FData.DIDTag.Artist[i],1);
        inc(siz,l+1);

        l := min(255,length(FData.DIDTag.Album));
        BlockWrite(f,l,1);
        for i:=1 to l do BlockWrite(f,FData.DIDTag.Album[i],1);
        inc(siz,l+1);

        fillchar(yr,sizeof(yr),0);
        for i:=1 to min(4,length(FData.DIDTag.Year)) do yr[i]:=FData.DIDTag.Year[i];
        BlockWrite(f,yr,4);
        inc(siz,4);

        l := min(255,length(FData.DIDTag.EncSoft));
        BlockWrite(f,l,1);
        for i:=1 to l do BlockWrite(f,FData.DIDTag.EncSoft[i],1);
        inc(siz,l+1);

        l := min(255,length(FData.DIDTag.EncodedBy));
        BlockWrite(f,l,1);
        for i:=1 to l do BlockWrite(f,FData.DIDTag.EncodedBy[i],1);
        inc(siz,l+1);

        l := min(255,length(FData.DIDTag.Comment));
        BlockWrite(f,l,1);
        for i:=1 to l do BlockWrite(f,FData.DIDTag.Comment[i],1);
        inc(siz,l+1);

        l := min(255,length(FData.DIDTag.Genre));
        BlockWrite(f,l,1);
        for i:=1 to l do BlockWrite(f,FData.DIDTag.Genre[i],1);
        inc(siz,l+1);

        inc(siz,6+2);

        blockwrite(f,siz,2);
        didoem:='ENDTAG';
        blockwrite(f,didoem,6);
      end;

      if FData.ID3v1Tag.isID3v1Tagged then
      begin
        fillchar(newtag,sizeof(newtag),0);
        newtag.Header:='TAG';
        with FData.ID3v1Tag do
        begin
          Move(Title[1], newtag.Title, Min(30,length(FData.ID3v1Tag.Title)));
          Move(Artist[1], newtag.Artist, Min(30,length(FData.ID3v1Tag.Artist)));
          Move(Album[1], newtag.Album, Min(30,length(FData.ID3v1Tag.Album)));
          Move(Year[1], newtag.Year, Min(4,length(FData.ID3v1Tag.Year)));
          Move(Comment[1], newtag.Comment, Min(30,length(FData.ID3v1Tag.Comment)));
          if (Track > 0) then
          begin
            newtag.Comment[29] := #0;
            newtag.Comment[30] := char(Track);
          end;
          newtag.Genre := Genre;
          BlockWrite(f,newtag,sizeof(newtag));
        end;
      end;
      Truncate(f);
    end;
    CloseFile(f);
    FReadData;
  end; { if }
  ShowProgress(100);
{$I+}
end; { WriteTag }

{----------------------------------------------}
function TMPEGAUDIO.RemoveDIDTag : integer;
var f : file;
{
    taghdr : tDIDHeader;
}
begin
  Result := -1;
  if FileExists (File_Name) then
  begin
    AssignFile (f, File_Name);

    FileMode := 2;
    {$I-}
    Reset (f,1);
    {$I+}
    Result := IOResult;

    CloseFile(f);
  end;
end;
{----------------------------------------------}
function TMPEGAUDIO.RemoveID3v2Tag : integer;
var f : file;
{
    taghdr : tID3v2Header;
}
begin
  Result := -1;
  if FileExists (File_Name) then
  begin
    AssignFile (f, File_Name);

    FileMode := 2;
    {$I-}
    Reset (f,1);
    {$I+}
    Result := IOResult;

    CloseFile(f);
  end;
end;
{----------------------------------------------}
function TMPEGAUDIO.RemoveID3v1Tag : Integer;
var f : file;
    tag : TID3v1Tag;

begin
  Result := -1;
  if FileExists (File_Name) then
  begin
    AssignFile (f, File_Name);

    FileMode := 2;
    {$I-}
    Reset (f,1);
    {$I+}
    Result := IOResult;
    if (not FatalIOError(Result)) and (FileSize(F) > sizeof(tag)) then
    begin
      Seek (f,FileSize(F)-sizeof(tag));
      BlockRead(f, tag, sizeof(tag));
      if tag.header='TAG' then
      begin
        Seek (f,FileSize(F)-sizeof(tag));
        Truncate (F);
      end;
      CloseFile(f);
    end;

    FReadData;
  end; { if }
end; { RemoveID3v1Tag }

{----------------------------------------------}
function TMPEGAUDIO.GenreStr : string;
begin
  Result := Genre;
end;

{----------------------------------------------}
function TMPEGAUDIO.ModeStr : string;
begin
  Result := MPEG_MODES[Mode]
end;

{----------------------------------------------}
function TMPEGAUDIO.DurationTime : TDateTime;
begin
  Result := SecondsToTime (Duration)
end;

{----------------------------------------------}
function TMPEGAUDIO.VersionStr : string;
begin
  Result := MPEG_VERSIONS[Version]
end;

{----------------------------------------------}
function TMPEGAUDIO.LayerStr : string;
begin
  { If (Layer > 3) then Data.Layer := 0; }
  Result := MPEG_LAYERS[Layer]
end;

{----------------------------------------------}
function TMPEGAUDIO.CopyrightStr (const CopyrightTrue, CopyrightFalse : string) : string;
begin
  Result := IIFStr (Copyright, CopyrightTrue, CopyrightFalse);
end;

{----------------------------------------------}
function TMPEGAUDIO.OriginalStr (const OriginalTrue, OriginalFalse : string) : string;
begin
  Result := IIFStr (Original, OriginalTrue, OriginalFalse);
end;

{----------------------------------------------}
function TMPEGAUDIO.ErrorProtectionStr (const ErrorProtectionTrue, ErrorProtectionFalse : string) : string;
begin
  Result := IIFStr (ErrorProtection, ErrorProtectionTrue, ErrorProtectionFalse);
end;

{----------------------------------------------}
function TMPEGAUDIO.SelectedStr (const SelectedTrue, SelectedFalse : string) : string;
begin
  Result := IIFStr (Selected > 0, SelectedTrue, SelectedFalse);
end;

{----------------------------------------------}
procedure TMPEGAUDIO.FSetMacro (MacroStr : string);
begin
  FMacro := (MacroStr);
  FText := Textilize (FMacro);
end;

{----------------------------------------------}
function TMPEGAUDIO.Textilize (MacroStr : string) : string;
begin
  Result := Macros.Textilize (MacroStr, self);
end;


{----------------------------------------------}
procedure TMPEGAUDIO.FSetArtist (inString : string);
begin
  Fdata.Artist := inString;
  FText := Textilize (FMacro);
end;

{----------------------------------------------}
function TMPEGAUDIO.FGetArtist : string;
begin
  if (Data.Artist='')and(FUnknownArtist <> '') then
    Result := FUnknownArtist
  else Result := Data.Artist;
end;

{----------------------------------------------}
procedure TMPEGAUDIO.FSetTitle (inString : string);
begin
  Fdata.Title := inString;
  FText := Textilize (FMacro);
end;

{----------------------------------------------}
function TMPEGAUDIO.FGetTitle : string;
begin
  if (Data.Title='')and(FUnknownTitle <> '') then
    Result := FUnknownTitle
  else Result := FData.Title;
end;

{----------------------------------------------}
procedure TMPEGAUDIO.FSetAlbum (inString : string);
begin
  Fdata.Album := inString;
  FText := Textilize (FMacro);
end;

{----------------------------------------------}
procedure TMPEGAUDIO.FSetYear (inString : string);
begin
  Fdata.Year := inString;
  FText := Textilize (FMacro);
end;

{----------------------------------------------}
procedure TMPEGAUDIO.FSetComment (inString : string);
begin
  Fdata.Comment := inString;
  FText := Textilize (FMacro);
end;

{----------------------------------------------}
procedure TMPEGAUDIO.FSetVolumeLabel (inString : string20);
begin
  Fdata.VolumeLabel := inString;
  FText := Textilize (FMacro);
end;

{----------------------------------------------}
procedure TMPEGAUDIO.FSetGenre (G : string);
begin
  Fdata.Genre := Genre;
  FText := Textilize (FMacro);
end;

{----------------------------------------------}
procedure TMPEGAUDIO.FSetTrack (inByte : string);
begin
  Fdata.Track := inByte;
  FText := Textilize (FMacro);
end;

{----------------------------------------------}
procedure TMPEGAUDIO.FSetSelected (inWord : word);
begin
  Fdata.Selected := inWord;
  FText := Textilize (FMacro);
end;


{************************************************************
 * TMACRODEFINITIONS methods                                *
 ************************************************************}

{----------------------------------------------}
constructor TMacroDefinitions.Create;
begin
  inherited Create;
  MacroDelimiterChar := '%';
end;

{----------------------------------------------}
destructor TMacroDefinitions.Free;
var
  i : Integer;
begin
  for i := Count-1 downto 0 do Items[i].Free;
  inherited Free;
end;

{----------------------------------------------}
function TMacroDefinitions.FGetMacroData (IndexNr : Integer) : TMacro;
begin
  Result := inherited Items[IndexNr];
end;

{----------------------------------------------}
function TMacroDefinitions.Add (ShortName,
                                LongName : string;
                                DefaultLength : Integer;
                                DefaultAlignment : char;
                                DefaultCapitalization : char;
                                Description,
                                Cathegory : string;
                                MacroType : TMacroDataType;
                                ValueProc : pointer;
                                CustomString : string) : Integer;

var
  MacroData : TMacro;
begin
  MacroData := TMacro.Create;
  MacroData.ShortName := ShortName;
  MacroData.LongName := LongName;
  MacroData.DefaultLength := DefaultLength;
  MacroData.DefaultAlignment := DefaultAlignment;
  MacroData.DefaultCapitalization := DefaultCapitalization;
  MacroData.Description := Description;
  MacroData.Cathegory := Cathegory;
  MacroData.MacroType := MacroType;
  MacroData.ValueProc := ValueProc;
  MacroData.CustomString := CustomString;
  Result := inherited Add (MacroData);
end;

{----------------------------------------------}
function TMacroDefinitions.Find (MacroName : string) : Integer;
var
  i : Integer;
begin
  MacroName := UpperCase (MacroName);
  Result := -1;
  for i := 0 to Count-1 do begin
    if (UpperCase (Items[i].LongName) = MacroName) or
       (UpperCase (Items[i].ShortName) = MacroName) then Result := i;
  end;
end;

{----------------------------------------------}
function GetMacroValue (MacroItem : string;
                        Macros : TMacroDefinitions;
                        MPEGAudio : TMPEGAudio) : string;
var
  MPEGAudioFunc : TGetMPEGAudioValue;
  SpecialFunc : TGetSpecialValue;
  MacroIndex : Integer;
  ItemName : string;
  ItemAlignment : char;
  ItemLength : Integer;
  ItemPadChar : char;
  ItemCapitalizeChar : char;
  tempstr : string;
  DefaultLength : integer;
  DefaultAlignment : char;
  DefaultCapitalization : char;

begin
  MacroItem := Copy (MacroItem, 2, Length (MacroItem)-2);
  ItemName := UpperCase (Trim (WordGet (MacroItem, 1, [','])));

  If ItemName = '' then Result := Macros.MacroDelimiterChar else
  begin
    DefaultAlignment := 'L';
    DefaultCapitalization := 'N';
    If IsNumber (ItemName) then
    begin
      ItemName := Chr (StrToIntDef (ItemName, 1));
      If ItemName = #0 then ItemName := #1;
      DefaultLength := 1;
    end else
    if (ItemName = 'NEWLINE') or (ItemName = 'NL') then begin
      ItemName := Chr (13) + Chr (10) + '';
      DefaultLength := 2;
    end else
    if (ItemName = 'SOFTNEWLINE') or (ItemName = '#') then
    begin
      ItemName := '';
      DefaultLength := 0;
    end else
    { ako je item TAB ubaciti tabulator }
    if (ItemName = 'TAB') or (ItemName = 'TB') then
    begin
      ItemName := #9;
      DefaultLength := 1;
    end else begin
      With Macros do begin
        MacroIndex := Find (ItemName);
        if (MacroIndex > -1) and
           not ((Items[MacroIndex].MacroType = mctMPEGAudio) and (MPEGAudio = nil))
        then begin
          if (Items[MacroIndex].ValueProc <> nil) or
             {$IFNDEF VER80}(Items[MacroIndex].MacroType = mctComplexMacro) or{$ENDIF}
             (Items[MacroIndex].MacroType = mctNoExec) then
          begin
            DefaultLength := Items[MacroIndex].DefaultLength;
            DefaultAlignment := Items[MacroIndex].DefaultAlignment;
            DefaultCapitalization := Items[MacroIndex].DefaultCapitalization;
            case Items[MacroIndex].MacroType of
              mctMPEGAudio :
                begin
                  MPEGAudioFunc := TGetMPEGAudioValue (Items[MacroIndex].ValueProc);
                  ItemName := Trim (MPEGAudioFunc (MPEGAudio));
                end;
              mctSpecial :
                begin
                  SpecialFunc := TGetSpecialValue (Items[MacroIndex].ValueProc);
                  ItemName := Trim (SpecialFunc);
                end;
              mctNoExec :
                begin
                  ItemName := ItemName + 'is NoExec Item!';
                  DefaultLength := Length (ItemName);
                end;
              {$IFNDEF VER80}
              mctComplexMacro :
                begin
                  ItemName := Textilize (Items[MacroIndex].CustomString,
                              MPEGAudio);
                end;
              {$ENDIF}
            else
              ItemName := MacroDelimiterChar + MacroItem + MacroDelimiterChar;
              MacroItem := '';
              DefaultLength := -1;
              DefaultAlignment := 'T';
              DefaultCapitalization := 'N';
            end; { case }
          end else begin
            ItemName := ItemName + ' association error!!! ';
            DefaultLength := Length (ItemName);
          end;
        end else begin
          ItemName := MacroDelimiterChar + MacroItem + MacroDelimiterChar;
          MacroItem := '';
          DefaultLength := -1;
          DefaultAlignment := 'T';
          DefaultCapitalization := 'N';
        end; { If MacroIndex... }
      end; { with }
    end; { if ItemName.. }

    { procitaj duzinu polja }
    TempStr := Trim (WordGet (MacroItem, 3, [',']));
    ItemLength := StrToIntDef (TempStr,-1);

    { procitaj nacin poravnanja polja }
    TempStr := UpperCase (Trim (WordGet (MacroItem, 2, [','])))+' ';
    If TempStr[1] IN ['L','R','C','T'] then
      ItemAlignment := TempStr[1]
    else begin
      ItemAlignment := DefaultAlignment;
      ItemLength := 0;
    end;

    { procitaj znak za popunjavanje }
    TempStr := Trim (WordGet (MacroItem, 4, [',']))+' ';
    ItemPadChar := TempStr[1];

    { procitaj znak za kapitalizaciju }
    TempStr := UpperCase (Trim (WordGet (MacroItem, 5, [','])))+' ';
    If TempStr[1] IN ['U','L','C','F','N'] then
      ItemCapitalizeChar := TempStr[1]
    else
      ItemCapitalizeChar := DefaultCapitalization;

    { izvrsi odgovarajucu kapitalizaciju polja }
    case ItemCapitalizeChar of
      {uppercase}    'U' : ItemName := UpperCase (ItemName);
      {lowercase}    'L' : ItemName := LowerCase (ItemName);
      {capitalize}   'C' : ItemName := Capitalize (ItemName, InterpunctionChars);
      {capitalfirst} 'F' : ItemName := CapitalFirst (ItemName);
                    else ItemName := ItemName;
    end; { case }
{    if (DefaultLength = 0) then ItemLength := -1;{}
    { ako se stavlja polje stvarne duzine, onda se izbegava bilo kakvo formatirnje }
    If (ItemLength < 0) then Result := ItemName
    else begin { u suprotnom mora se formatirati sadrzaj pre stavljanja u izlaznu datoteku }

      { ako je duzina polja 0 to znaci da se koristi default duzina polja }
      if ItemLength = 0 then if DefaultLength = 0 then ItemLength := length(ItemName) else ItemLength := DefaultLength;
      {$IFDEF VER80}
        if ItemLength > 255 then ItemLength := 255;
      {$ENDIF}

      Case ItemAlignment of
        { levo poravnanje }
        'L' : ItemName := PadLeft (ItemName, ItemLength, ItemPadChar);
        { desno poravnanje }
        'R' : ItemName := PadRight (ItemName, ItemLength, ItemPadChar);
        { centrirano }
        'C' : ItemName := PadCenter (ItemName, ItemLength, ItemPadChar);
        { trimovano }
        'T' : ItemName := ItemName;
      end; { case }
      Result := ItemName;
    end; { if }
  end; { if }
end; { function }

{----------------------------------------------}
function TMacroDefinitions.GetValue (MacroItem : string;
                                     MPEGAudio : TMPEGAudio) : string;
begin
  Result := GetMacroValue (MacroItem, Self, MPEGAudio)
end;


{----------------------------------------------}
function TMacroDefinitions.Textilize (MacroStr : string;
                                      MPEGAudio : TMPEGAudio) : string;
var
  nextpart : integer;
  InStrLen : integer;
  ItemPos : Integer;
  ItemLast : integer;
  ItemStr : string;
  ItemOut : string;
  OutStr : string;
begin
  outStr := '';
  nextpart := 1;
  InStrLen := Length (MacroStr);

  while nextpart <= InStrLen do begin
    itemPos := PosFirst (MacroStr, MacroDelimiterChar, nextpart);
    If (ItemPos - nextpart) > 0 then
      Outstr := OutStr + Copy (MacroStr,nextpart, ItemPos-NextPart);
    If ItemPos <> 0 then begin
      itemLast := PosFirst (MacroStr, MacroDelimiterChar, ItemPos+1);
      If ItemLast <> 0 then begin
        ItemStr := Copy (MacroStr, ItemPos+1, ItemLast-ItemPos-1);
        nextpart := ItemLast+1;
        ItemOut := GetMacroValue (MacroDelimiterChar+ItemStr+MacroDelimiterChar, Self, MPEGAudio);

        If Length (ItemOut) > 0 then OutStr := OutStr + ItemOut;
      end else begin
        OutStr := OutStr + '<<<ERROR!!! No end of item definition!>>>';
        nextPart := InStrLen+1;
      end; { if }
    end else begin
      OutStr := OutStr + Copy (MacroStr, nextpart, InStrLen);
      nextPart := InStrLen+1;
    end;
  end; { while }
  Result := outstr;
end;

{----------------------------------------------}
function TMacroDefinitions.FCompareMacroItems (Item1, Item2: pointer): Integer;
var
  M1, M2 : TMacro;
begin
  M1 := Item1;
  M2 := Item2;
  If (M1.Cathegory + M1.LongName) > (M2.Cathegory + M2.LongName) then
    Result := 1
  else
    If (M1.Cathegory + M1.LongName) < (M2.Cathegory + M2.LongName) then
      Result := -1
    else Result := 0;
end;


{----------------------------------------------}
procedure TMacroDefinitions.Sort;
var
  Compare : TListSortCompare;
begin
 Compare := FCompareMacroItems;
 if (List <> nil) and (Count > 0) then
    QuickSort(List, 0, Count - 1, Compare, 1, nil)
end;


{************************************************************
TMacroDefinitions supporting functions (private)
************************************************************}

function GetMPEGFileName (const MPEGAudio : TMPEGAudio) : string;
begin
  Result := ExtractFileName (MPEGAudio.File_Name);
end;

{$IFNDEF VER80}
function GetMPEGFileNameShort (const MPEGAudio : TMPEGAudio) : string;
begin
  Result := ExtractFileName (MPEGAudio.FileNameShort);
end;
{$ENDIF}

function GetMPEGFilePath (const MPEGAudio : TMPEGAudio) : string;
begin
  Result := ExtractFilePath (MPEGAudio.File_Name);
end;

function GetMPEGVolumeLabel (const MPEGAudio : TMPEGAudio) : string;
begin
  Result := ExtractFileName (MPEGAudio.VolumeLabel);
end;

function GetMPEGTitle (const MPEGAudio : TMPEGAudio) : string;
begin
  Result := MPEGAudio.Title;
end;

function GetMPEGExtractedArtist (const MPEGAudio : TMPEGAudio) : string;
var
  DelimiterPos : Integer;
begin
  Result := ExtractFileName (MPEGAudio.File_Name);
  DelimiterPos := Pos (FileNameDataDelimiter, Result);
  If DelimiterPos > 0 then
    Result := Trim (Copy (Result, 1, DelimiterPos - 1))
  else Result := '';
end;

function GetMPEGGuessedArtist (const MPEGAudio : TMPEGAudio) : string;
begin
  if (MPEGAudio.Data.ID3v1Tag.isID3v1Tagged)or(MPEGAudio.Data.ID3v2Tag.isID3v2Tagged)or(MPEGAudio.Data.DIDTag.IsDIDTagged) then
    Result := MPEGAudio.Artist
  else begin
    Result := GetMPEGExtractedArtist (MPEGAudio);
    if Result = '' then Result := MPEGAudio.UnknownArtist;
  end;
end;


function GetMPEGExtractedTitle (const MPEGAudio : TMPEGAudio) : string;
var
  DelimiterPos : Integer;
begin
  Result := ExtractFileName (MPEGAudio.File_Name);
  DelimiterPos := Pos (FileNameDataDelimiter, Result);
  if DelimiterPos > 0 then
    Result := Trim (Copy (Result, DelimiterPos + 1, Length (Result)))
  else Result := '';
  for DelimiterPos := Length (Result) downto 1 do
    if Result[DelimiterPos] = '.' then begin
      Result := Copy (Result, 1, DelimiterPos - 1);
      Break;
    end;
end;

function GetMPEGGuessedTitle (const MPEGAudio : TMPEGAudio) : string;
begin
  if (MPEGAudio.Data.ID3v1Tag.isID3v1Tagged)or(MPEGAudio.Data.ID3v2Tag.isID3v2Tagged)or(MPEGAudio.Data.DIDTag.IsDIDTagged) then
    Result := MPEGAudio.Title
  else begin
    Result := GetMPEGExtractedTitle (MPEGAudio);
    if Result = '' then Result := MPEGAudio.UnknownTitle;
  end;
end;

function GetMPEGFileDate (const MPEGAudio : TMPEGAudio) : string;
begin
  Result := DateToStr (MPEGAudio.FileDateTime);
end;

function GetMPEGFileDateTimeforSort (const MPEGAudio : TMPEGAudio) : string;
begin
  Result := FormatDateTime ('yyyymmddhhnnss', MPEGAudio.FileDateTime);
end;

function GetMPEGFileTime (const MPEGAudio : TMPEGAudio) : string;
begin
  Result := TimeToStr (MPEGAudio.FileDateTime);
end;

function GetMPEGArtist (const MPEGAudio : TMPEGAudio) : string;
begin
  Result := MPEGAudio.Artist;
end;

function GetMPEGAlbum (const MPEGAudio : TMPEGAudio) : string;
begin
  Result := MPEGAudio.Album;
end;

function GetMPEGYear (const MPEGAudio : TMPEGAudio) : string;
begin
  Result := MPEGAudio.Year;
end;

function GetMPEGComment (const MPEGAudio : TMPEGAudio) : string;
begin
  Result := MPEGAudio.Comment;
end;

function GetMPEGGenre (const MPEGAudio : TMPEGAudio) : string;
begin
  Result := MPEGAudio.GenreStr;
end;

function GetMPEGTrack (const MPEGAudio : TMPEGAudio) : string;
begin
  Result := MPEGAudio.Track;
end;

function GetMPEGDuration (const MPEGAudio : TMPEGAudio) : string;
begin
  Result := IntToStr (MPEGAudio.Duration)
end;

function GetMPEGDurationComma (const MPEGAudio : TMPEGAudio) : string;
begin
  Result := Format ('%20.0n', [MPEGAudio.Duration/1]);
end;

function GetMPEGDurationMinutes (const MPEGAudio : TMPEGAudio) : string;
begin
  Result := Format ('%20.1n', [MPEGAudio.Duration/60])
end;

function GetMPEGDurationMinutesComma (const MPEGAudio : TMPEGAudio) : string;
begin
  Result := Format ('%20.1n', [MPEGAudio.Duration/60]);
end;

function GetMPEGDurationForm (const MPEGAudio : TMPEGAudio) : string;
begin
{  Result := FormatDateTime ('n' + TimeSeparator + 'ss', SecondsToTime (MPEGAudio.Duration));{}
  Result := TimeSt(MPEGAudio.Duration,true);
end;

function GetMPEGLength (const MPEGAudio : TMPEGAudio) : string;
begin
  Result := IntToStr (MPEGAudio.FileLength);
end;

function GetMPEGLengthComma (const MPEGAudio : TMPEGAudio) : string;
begin
  Result := Format ('%20.0n', [MPEGAudio.FileLength/1]);
end;

function GetMPEGLengthKB (const MPEGAudio : TMPEGAudio) : string;
begin
  Result := IntToStr (MPEGAudio.FileLength DIV 1024);
end;

function GetMPEGLengthKBComma (const MPEGAudio : TMPEGAudio) : string;
begin
  Result := Format ('%20.0n', [MPEGAudio.FileLength / 1024]);
end;

function GetMPEGLengthMB (const MPEGAudio : TMPEGAudio) : string;
begin
  Result := Format ('%20.1f', [MPEGAudio.FileLength / (1024*1024)]);
  If Result [Length(Result)] = DecimalSeparator then Result := Result + '0';
end;

function GetMPEGVersion (const MPEGAudio : TMPEGAudio) : string;
begin
  Result := MPEG_VERSIONS [MPEGAudio.Version];
end;

function GetMPEGLayer (const MPEGAudio : TMPEGAudio) : string;
begin
  Result := MPEGAudio.LayerStr;
end;

function GetMPEGLayerNr (const MPEGAudio : TMPEGAudio) : string;
begin
  Result := IntToStr (MPEGAudio.Layer);
end;

function GetMPEGSampleRate (const MPEGAudio : TMPEGAudio) : string;
begin
  Result := IntToStr (MPEGAudio.SampleRate);
end;

function GetMPEGSampleRateKHz (const MPEGAudio : TMPEGAudio) : string;
begin
  Result := Format ('%4.1f', [MPEGAudio.SampleRate/1000]);
  If Result [Length(Result)] = DecimalSeparator then Result := Result + '0';
end;

function GetMPEGBitRate (const MPEGAudio : TMPEGAudio) : string;
begin
  if MPEGAudio.BitRate <> -1 then
    Result := IntToStr (MPEGAudio.BitRate)
  else Result := 'VBR';
end;

function GetMPEGErrorProt (const MPEGAudio : TMPEGAudio) : string;
begin
  Result := MPEGAudio.ErrorProtectionStr ('Yes','No');
end;

function GetMPEGErrorProtA (const MPEGAudio : TMPEGAudio) : string;
begin
  Result := MPEGAudio.ErrorProtectionStr ('*',' ');
end;

function GetMPEGCopyright (const MPEGAudio : TMPEGAudio) : string;
begin

  Result := MPEGAudio.CopyrightStr ('Yes','No');
end;

function GetMPEGCopyrightA (const MPEGAudio : TMPEGAudio) : string;
begin
  Result := MPEGAudio.CopyrightStr ('*',' ');
end;

function GetMPEGOriginal (const MPEGAudio : TMPEGAudio) : string;
begin
  Result := MPEGAudio.OriginalStr ('Yes','No');
end;

function GetMPEGOriginalA (const MPEGAudio : TMPEGAudio) : string;
begin
  Result := MPEGAudio.OriginalStr ('*',' ');
end;

function GetMPEGMode (const MPEGAudio : TMPEGAudio) : string;
begin
  Result := MPEGAudio.ModeStr;
end;

function GetMPEGStereo (const MPEGAudio : TMPEGAudio) : string;
begin
  Result := IIFStr (MPEGAudio.Mode <> 3,'Stereo','Mono');
end;

function GetProgramVersion : string;
begin
  Result := 'MPGTools ' + UnitVersion;
end;

function GetCurrentSystemDate : string;
begin
  Result := DateToStr (Now);
end;

function GetCurrentSystemTime : string;
begin
  Result := TimeToStr (Now);
end;

  INITIALIZATION

BEGIN
  Macros := TMacroDefinitions.Create;
  With Macros do
  begin
    { mctMPEG Audio }
    Add ('FN','FileName',0,'L','N',
         'Имя файла', 'MPEG Audio File', mctMPEGAudio, @GetMPEGFileName, '');
    {$IFNDEF VER80}
    Add ('FNS','FileNameShort',0,'L','N',
         'Короткое имя файла (8+3)', 'MPEG Audio File', mctMPEGAudio, @GetMPEGFileNameShort, '');
    {$ENDIF}
    Add ('FP','FilePath',0,'L','N',
         'Путь к файлу (без имени)', 'MPEG audio file', mctMPEGAudio, @GetMPEGFilePath, '');
    Add ('VL','VolumeLabel',0,'L','N',
         'Метка диска', 'MPEG audio file', mctMPEGAudio, @GetMPEGVolumeLabel, '');
    Add ('T','Title',0,'L','N',
         'Название песни', 'MPEG audio file', mctMPEGAudio, @GetMPEGTitle, '');
    Add ('ET','ExtractedTitle',0,'L','N',
         'Исполнитель, извлеченный из имени файла', 'MPEG audio file', mctMPEGAudio, @GetMPEGExtractedTitle, '');
    Add ('GT','GuessedTitle',0,'L','N',
         'Название угаданное из TAG или из имени файла', 'MPEG audio file', mctMPEGAudio, @GetMPEGGuessedTitle, '');
    Add ('FD','FileDate',0,'L','N',
         'Дата последнего изменения файла', 'MPEG audio file', mctMPEGAudio, @GetMPEGFileDate, '');
    Add ('FDTFS','FileDateTimeForSort',14,'L','N',
         'Дата-время файла (формат для сортировки : yyyymmddhhmmss)','MPEG audio file', mctMPEGAudio, @GetMPEGFileDateTimeForSort, '');
    Add ('FT','FileTime',0,'L','N',
         'Время последнего изменения файла', 'MPEG audio file', mctMPEGAudio, @GetMPEGFileTime, '');
    Add ('A','Artist',0,'L','N',
         'Исполнитель', 'MPEG audio file', mctMPEGAudio, @GetMPEGArtist, '');
    Add ('EA','ExtractedArtist',0,'L','N',
         'Исполнитель, извлеченный из имени', 'MPEG audio file', mctMPEGAudio, @GetMPEGExtractedArtist, '');
    Add ('GA','GuessedArtist',0,'L','N',
         'Исполнитель, извлеченный из TAG-а или имени', 'MPEG audio file', mctMPEGAudio, @GetMPEGGuessedArtist, '');
    Add ('ALB','Album',0,'L','N',
         'Альбом', 'MPEG audio file',mctMPEGAudio, @GetMPEGAlbum, '');
    Add ('Y','Year',0,'L','N',
         'Год', 'MPEG audio file',mctMPEGAudio, @GetMPEGYear, '');
    Add ('CMNT','Comment',0,'L','N',
         'Комментарий', 'MPEG audio file',mctMPEGAudio, @GetMPEGComment, '');
    Add ('G','Genre',0,'L','N',
         'Жанр/стиль', 'MPEG audio file',mctMPEGAudio, @GetMPEGGenre, '');
    Add ('TR','Track',0,'R','N',
         'Номер трэка', 'MPEG audio file',mctMPEGAudio, @GetMPEGTrack, '');
    Add ('D','Duration',0,'R','N',
         'Длительность (в секундах)','MPEG audio file',mctMPEGAudio, @GetMPEGDuration, '');
    Add ('DC','DurationComma',0,'R','N',
         'Длительность (в секундах), с разделением тысяч', 'MPEG audio file', mctMPEGAudio, @GetMPEGDurationComma, '');
    Add ('DM','DurationMinutes',0,'R','N',
         'Длительность (в минутах)','MPEG audio file', mctMPEGAudio, @GetMPEGDurationMinutes, '');
    Add ('DMC','DurationMinutesComma',0,'R','N',
         'Длительность (в минутах), с разделением тысяч', 'MPEG audio file', mctMPEGAudio, @GetMPEGDurationMinutesComma, '');
    Add ('DF','DurationForm',0,'R','N',
         'Длительность (формат ММ:СС)','MPEG audio file',mctMPEGAudio, @GetMPEGDurationForm, '');
    Add ('L','Length',0,'R','N',
         'Размер файла в байтах','MPEG audio file',mctMPEGAudio, @GetMPEGLength, '');
    Add ('LC','LengthComma',0,'R','N',
         'Размер файла (в байтах), с разделением тысяч', 'MPEG audio file',mctMPEGAudio, @GetMPEGLengthComma, '');
    Add ('LK','LengthKB',0,'R','N',
         'Размер файла (в килобайтах)','MPEG audio file', mctMPEGAudio, @GetMPEGLengthKB, '');
    Add ('LKC','LengthKBComma',0,'R','N',
         'Размер файла (в килобайтах), с разделением тысяч','MPEG audio file', mctMPEGAudio, @GetMPEGLengthKBComma, '');
    Add ('LM','LengthMB',0,'R','N',
         'Размер файла (в мегабайтах)', 'MPEG audio file', mctMPEGAudio, @GetMPEGLengthMB, '');
    Add ('V','Version',0,'L','N',
         'Версия MPEG', 'MPEG audio file', mctMPEGAudio, @GetMPEGVersion, '');
    Add ('LY','Layer',0,'L','N',
         'Тип Слоя MPEG (I, II, III или unknown)', 'MPEG audio file', mctMPEGAudio, @GetMPEGLayer, '');
    Add ('LYN','LayerNr',0,'L','N',
         'Тип Слоя MPEG (1, 2, 3 или unknown)', 'MPEG audio file', mctMPEGAudio, @GetMPEGLayerNr, '');
    Add ('SR','SampleRate',0,'R','N',
         'Частота сэмплов (khz)', 'MPEG audio file', mctMPEGAudio, @GetMPEGSampleRate, '');
    Add ('SRK','SampleRateKHz',0,'R','N',
         'Частота сэмплов (в килобайтах) ', 'MPEG audio file', mctMPEGAudio, @GetMPEGSampleRateKHz, '');
    Add ('BR','BitRate',0,'R','N',
         'BitRate (в килобайтах)', 'MPEG audio file', mctMPEGAudio, @GetMPEGBitRate, '');
    Add ('EP','ErrorProt',1,'L','N',
         'MPEG Error protection (''Yes''/''No'')', 'MPEG audio file', mctMPEGAudio, @GetMPEGErrorProt, '');
    Add ('EP*','ErrorProt*',1,'L','N',
         'MPEG Error Protection (''*''/'' '')', 'MPEG audio file', mctMPEGAudio, @GetMPEGErrorProtA, '');
    Add ('C','Copyright',0,'L','N',
         'MPEG Copyrighted (''Yes''/''No'')', 'MPEG audio file', mctMPEGAudio, @GetMPEGCopyright, '');
    Add ('C*','Copyright*',1,'L','N',
         'MPEG Copyrighted (''*''/'' '')', 'MPEG audio file', mctMPEGAudio, @GetMPEGCopyrightA, '');
    Add ('O','Original',0,'L','N',
         'MPEG Original (''Yes''/''No'')', 'MPEG audio file', mctMPEGAudio, @GetMPEGOriginal, '');
    Add ('O*','Original*',0,'L','N',
         'MPEG Original (''*''/'' '')', 'MPEG audio file', mctMPEGAudio, @GetMPEGOriginalA, '');
    Add ('M','Mode',0,'L','N',
         'Режим каналов (''Stereo''/''Joint-Stereo''/''Dual-Channel''/''Mono'')',
         'MPEG audio file', mctMPEGAudio, @GetMPEGMode, '');
    Add ('S','Stereo',0,'L','N',
         'Стерео режим (''Stereo''/''Mono'')', 'MPEG audio file', mctMPEGAudio, @GetMPEGStereo, '');

    { mctSpecial }
    Add ('PV','ProgramVersion',Length (GetProgramVersion),'L','N',
         'Версия модуля обработки', 'System', mctSpecial, @GetProgramVersion, '');
    Add ('CD','CurrentDate',0,'R','N',
         'Текущая системная дата', 'System', mctSpecial, @GetCurrentSystemDate, '');
    Add ('CT','CurrentTime',0,'R','N',
         'Текущее системное время', 'System', mctSpecial, @GetCurrentSystemDate, '');

    { mctNoExec }
    Add ('NL','NewLine',2,'L','N',
         'Новая строка (CRLF)', 'Special', mctNoExec, nil, '');
    Add ('#','SoftNewLine',2,'L','N',
         'Мягкий перевод строки', 'Special', mctNoExec, nil, '');
    Add ('TB','Tab',1,'L','N',
         'Табуляция', 'Special', mctNoExec, nil, '');
    Add ('nnn','nnn',1,'L','N',
         'Код символа ASCII (десятичный)', 'Special', mctNoExec, nil, '');
    Add ('','',1,'L','N',
         'Знак процента (%)', 'Special', mctNoExec, nil, '');


    {$IFNDEF VER80}
    { mctComplexMacro }
    Add ('FPN','FilePathName',80,'L','N',
         'Путь и имя файла', 'MPEG audio file', mctComplexMacro, nil, '%FP,T%%FN,T%');
    Add ('GAT','GuessedArtistTitle',80,'L','N',
         'Артист и исполнитель, угаданные из TAG-а или имени файла', 'MPEG audio file', mctComplexMacro, nil, '%GA,T% - %GT,T%');
    {$ENDIF}

end; { with }

  { initializing MusicStyle array contents. Its done this way since it
    is much easier to mantain the list }

  { Array Re-arranged (c) D.J. NiKe }
  Genres[000]:=  'Blues';
  Genres[001]:=  'Classic Rock';
  Genres[002]:=  'Country';
  Genres[003]:=  'Dance';
  Genres[004]:=  'Disco';
  Genres[005]:=  'Funk';
  Genres[006]:=  'Grunge';
  Genres[007]:=  'Hip-Hop';
  Genres[008]:=  'Jazz';
  Genres[009]:=  'Metal';
  Genres[010]:=  'New Age';
  Genres[011]:=  'Oldies';
  Genres[012]:=  'Other';
  Genres[013]:=  'Pop';
  Genres[014]:=  'R&B';
  Genres[015]:=  'Rap';
  Genres[016]:=  'Reggae';
  Genres[017]:=  'Rock';
  Genres[018]:=  'Techno';
  Genres[019]:=  'Industrial';
  Genres[020]:=  'Alternative';
  Genres[021]:=  'Ska';
  Genres[022]:=  'Death Metal';
  Genres[023]:=  'Pranks';
  Genres[024]:=  'Soundtrack';
  Genres[025]:=  'Euro-Techno';
  Genres[026]:=  'Ambient';
  Genres[027]:=  'Trip-Hop';
  Genres[028]:=  'Vocal';
  Genres[029]:=  'Jazz+Funk';
  Genres[030]:=  'Fusion';
  Genres[031]:=  'Trance';
  Genres[032]:=  'Classical';
  Genres[033]:=  'Instrumental';
  Genres[034]:=  'Acid';
  Genres[035]:=  'House';
  Genres[036]:=  'Game';
  Genres[037]:=  'Sound Clip';
  Genres[038]:=  'Gospel';
  Genres[039]:=  'Noise';
  Genres[040]:=  'Alt. Rock';
  Genres[041]:=  'Bass';
  Genres[042]:=  'Soul';
  Genres[043]:=  'Punk';
  Genres[044]:=  'Space';
  Genres[045]:=  'Meditative';
  Genres[046]:=  'Instrumental Pop';
  Genres[047]:=  'Instrumental Rock';
  Genres[048]:=  'Ethnic';
  Genres[049]:=  'Gothic';
  Genres[050]:=  'Darkwave';
  Genres[051]:=  'Techno-Industrial';
  Genres[052]:=  'Electronic';
  Genres[053]:=  'Pop-Folk';
  Genres[054]:=  'Eurodance';
  Genres[055]:=  'Dream';
  Genres[056]:=  'Southern Rock';
  Genres[057]:=  'Comedy';
  Genres[058]:=  'Cult';
  Genres[059]:=  'Gangsta Rap';
  Genres[060]:=  'Top 40';
  Genres[061]:=  'Christian Rap';
  Genres[062]:=  'Pop/Funk';
  Genres[063]:=  'Jungle';
  Genres[064]:=  'Native American';
  Genres[065]:=  'Cabaret';
  Genres[066]:=  'New Wave';
  Genres[067]:=  'Psychedelic';
  Genres[068]:=  'Rave';
  Genres[069]:=  'Showtunes';
  Genres[070]:=  'Trailer';
  Genres[071]:=  'Lo-Fi';
  Genres[072]:=  'Tribal';
  Genres[073]:=  'Acid Punk';
  Genres[074]:=  'Acid Jazz';
  Genres[075]:=  'Polka';
  Genres[076]:=  'Retro';
  Genres[077]:=  'Musical';
  Genres[078]:=  'Rock & Roll';
  Genres[079]:=  'Hard Rock';
{ Добавлено 12.12.1997 (Winamp) }
  Genres[080]:=  'Folk';
  Genres[081]:=  'Folk/Rock';
  Genres[082]:=  'National Folk';
  Genres[083]:=  'Swing';
  Genres[084]:=  'Fast-Fusion';
  Genres[085]:=  'Bebob';
  Genres[086]:=  'Latin';
  Genres[087]:=  'Revival';
  Genres[088]:=  'Celtic';
  Genres[089]:=  'Bluegrass';
  Genres[090]:=  'Avantgarde';
  Genres[091]:=  'Gothic Rock';
  Genres[092]:=  'Progressive Rock';
  Genres[093]:=  'Psychedelic Rock';
  Genres[094]:=  'Symphonic Rock';
  Genres[095]:=  'Slow Rock';
  Genres[096]:=  'Big Band';
  Genres[097]:=  'Chorus';
  Genres[098]:=  'Easy Listening';
  Genres[099]:=  'Acoustic';
  Genres[100]:=  'Humour';
  Genres[101]:=  'Speech';
  Genres[102]:=  'Chanson';
  Genres[103]:=  'Opera';
  Genres[104]:=  'Chamber Music';
  Genres[105]:=  'Sonata';
  Genres[106]:=  'Symphony';
  Genres[107]:=  'Booty Bass';
  Genres[108]:=  'Primus';
  Genres[109]:=  'Porn Groove';
  Genres[110]:=  'Satire';
{ Добавлено 26.01.1998 (Winamp 1.7) }
  Genres[111]:=  'Slow Jam';
  Genres[112]:=  'Club';
  Genres[113]:=  'Tango';
  Genres[114]:=  'Samba';
  Genres[115]:=  'Folklore';
{ Добавлено 13.04.1998 (Winamp 1.90) }
  Genres[116]:=  'Ballad';
  Genres[117]:=  'Power Ballad';
  Genres[118]:=  'Rhythmic Soul';
  Genres[119]:=  'Freestyle';
  Genres[120]:=  'Duet';
  Genres[121]:=  'Punk Rock';
  Genres[122]:=  'Drum Solo';
  Genres[123]:=  'A Cappella';
  Genres[124]:=  'Euro-House';
  Genres[125]:=  'Dance Hall';
  Genres[126]:=  'Goa';
  Genres[127]:=  'Drum & Bass';
  Genres[128]:=  'Club-House';
  Genres[129]:=  'Hardcore';
  Genres[130]:=  'Terror';
  Genres[131]:=  'Indie';
  Genres[132]:=  'BritPop';
  Genres[133]:=  'Negerpunk';
  Genres[134]:=  'Polsk Punk';
  Genres[135]:=  'Beat';
  Genres[136]:=  'Christian Gangsta Rap';
  Genres[137]:=  'Heavy Metal';
  Genres[138]:=  'Black Metal';
  Genres[139]:=  'Crossover';
  Genres[140]:=  'Contemporary Christian';
  Genres[141]:=  'Christian Rock';
{ Добавлено 01.06.1998 (Winamp 1.91) }
  Genres[142]:=  'Merengue';
  Genres[143]:=  'Salsa';
  Genres[144]:=  'Thrash Metal';
  Genres[145]:=  'Anime';
  Genres[146]:=  'JPop';
  Genres[147]:=  'Synthpop';

{ Добавлено (c) 10/02/2001 D.J. NiKe, MP3 NaviGatoR v2.1}
  AddGenres[0]:= 'Breakbeat';
{ Добавлено (c) 12/02/2001 D.J. NiKe, MP3 NaviGatoR v2.1}
  AddGenres[1]:= 'Garage';
{ Добавлено (c) 25/02/2001 D.J. NiKe, MP3 NaviGatoR v2.1}
  AddGenres[2]:= 'Progressive House';
{ Добавлено (c) 19/07/2001 D.J. NiKe, MP3 NaviGatoR v2.2}
  AddGenres[3]:= 'Speed Garage';
  AddGenres[4]:= 'Rapcore';
{ Добавлено (c) 04/09/2001 D.J. NiKe, MP3 NaviGatoR v2.4}
  AddGenres[5]:= 'Jump Up';
{ Добавлено (c) 07/01/2002 D.J. NiKe, MP3 NaviGatoR v2.5}
  AddGenres[6]:= 'IDM'; {Intelligent Dance Music}
end;

END.