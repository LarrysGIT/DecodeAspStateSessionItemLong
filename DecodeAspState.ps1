
function Decode-AspStateSessionLongItem
{
    PARAM(
        [byte[]]$SessionItemLong_Bytes,
        [switch]$ValueOnly = $false
    )
    [System.Reflection.Assembly]::LoadWithPartialName("System.Web") | Out-Null
    if(!$ValueOnly)
    {
        try
        {
            Get-ChildItem -Filter *.dll | %{
                [System.Reflection.Assembly]::LoadFrom($_.FullName) | Out-Null
            }
        }
        catch
        {
            Write-Warning $_.Exception.Message
        }
    }
    $ms = [System.IO.MemoryStream]$SessionItemLong_Bytes
    $reader = [System.IO.BinaryReader]$ms
    $length = $reader.ReadInt32()
    $f1 = $reader.ReadBoolean()
    $f2 = $reader.ReadBoolean()

    $items = $null
    $sitems = $null
    if($f1)
    {
        $items = [System.Web.SessionState.SessionStateItemCollection]::Deserialize($reader)
    }

    if($f2)
    {
        $sitems = [System.Web.HttpStaticObjectsCollection]::Deserialize($reader)
    }

    if($reader.ReadByte() -ne 0xFF)
    {
        throw "Corrupt"
    }

    if($items)
    {
        for($i = 0; $i -lt $items.Count; $i++)
        {
            $obj = $null
            $obj = $items[$i]
            if($obj)
            {
                if($ValueOnly)
                {
                    Write-Output ("{0}" -f $obj.ToString())
                }
                else
                {
                    Write-Output ("{0}={1}" -f $items.Keys[$i], $obj.ToString())
                }
            }
        }
    }
    $ms.Close()
    $reader.Close()
}
