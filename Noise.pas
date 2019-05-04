{ ******************************************************************************
  Class TNoise
  Source from: https://forums.embarcadero.com/thread.jspa?threadID=108356
*******************************************************************************}

unit Noise;

interface
uses
  System.Classes, SysUtils, Windows, MMSystem, Dialogs;

type
  TVolumeLevel = 0..127;

  TNoise = class
  private
    ms: TMemoryStream;
  public
    constructor Create(Frequency{Hz}, Duration{mSec}: Integer; Volume: TVolumeLevel);
    destructor Destroy; override;
    procedure Play;
  end;

implementation

{ TNoise }

constructor TNoise.Create(Frequency, Duration: Integer; Volume: TVolumeLevel);
var
   WaveFormatEx: TWaveFormatEx;
   i, TempInt, DataCount, RiffCount: integer;
   SoundValue: byte;
   w: double; // omega ( 2 * pi * frequency)
const
   Mono: Word = $0001;
   SampleRate: Integer = 11025; // 8000, 11025, 22050, or 44100
   RiffId: ansistring = 'RIFF';
   WaveId: ansistring = 'WAVE';
   FmtId: ansistring = 'fmt ';
   DataId: ansistring = 'data';
begin
   if Frequency > (0.6 * SampleRate) then
   begin
     ShowMessage(Format('Sample rate of %d is too Low to play a tone of %dHz',
       [SampleRate, Frequency]));
     Exit;
   end;
   with WaveFormatEx do
   begin
     wFormatTag := WAVE_FORMAT_PCM;
     nChannels := Mono;
     nSamplesPerSec := SampleRate;
     wBitsPerSample := $0008;
     nBlockAlign := (nChannels * wBitsPerSample) div 8;
     nAvgBytesPerSec := nSamplesPerSec * nBlockAlign;
     cbSize := 0;
   end;
   MS := TMemoryStream.Create;
   with MS do
   begin
     {Calculate length of sound data and of file data}
     DataCount := (Duration * SampleRate) div 1000; // sound data
     RiffCount := Length(WaveId) + Length(FmtId) + SizeOf(DWORD) +
       SizeOf(TWaveFormatEx) + Length(DataId) + SizeOf(DWORD) + DataCount; // file data
     {write out the wave header}
     Write(RiffId[1], 4); // 'RIFF'
     Write(RiffCount, SizeOf(DWORD)); // file data size
     Write(WaveId[1], Length(WaveId)); // 'WAVE'
     Write(FmtId[1], Length(FmtId)); // 'fmt '
     TempInt := SizeOf(TWaveFormatEx);
     Write(TempInt, SizeOf(DWORD)); // TWaveFormat data size
     Write(WaveFormatEx, SizeOf(TWaveFormatEx)); // WaveFormatEx record
     Write(DataId[1], Length(DataId)); // 'data'
     Write(DataCount, SizeOf(DWORD)); // sound data size
     {calculate and write out the tone signal} // now the data values
     w := 2 * Pi * Frequency; // omega
     for i := 0 to DataCount - 1 do
     begin
       SoundValue := 127 + trunc(Volume * sin(i * w / SampleRate)); // wt = w * i / SampleRate
       Write(SoundValue, SizeOf(Byte));
     end;
   end;
end;

destructor TNoise.Destroy;
begin
  ms.Free;
  inherited;
end;

procedure TNoise.Play;
begin
  sndPlaySound(MS.Memory, SND_MEMORY or SND_ASYNC);
end;

end.
