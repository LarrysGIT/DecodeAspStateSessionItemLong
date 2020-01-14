# Decode [AspState].[dbo].[ASPStateTempSessions].[SessionLongItem]

This is a powershell script to decode data from column `SessionLongItem`

Thanks to https://stackoverflow.com/questions/967497/asp-net-sessionstate-using-sql-server-is-the-data-encrypted/

## Where is AspSession data stored?

All sessions,

`select * from [ASPStateV2].[dbo].[ASPStateTempSessions]`

For logged in sessions, column `SessionItemLong` is not `null` and `SessionItemShort` is `null`

For logged out sessions, column `SessionItemLong` is `null` and `SessionItemShort` is not `null`

## So, how to decode bytes from `SessionItemLong`?

```
> [byte[]]$data = @(0,1,2,3,4,5,6,7,8.......)
> . .\DecodeAspState.ps1
> Decode-AspStateSessionLongItem -SessionItemLong_Bytes $data -ValueOnly
Value1
Value2
Value3
> Decode-AspStateSessionLongItem -SessionItemLong_Bytes $data
Key1=Value1
Key2=Value2
Key3=Value3
```

## `Key` and `Value`?

You may get some error like following. Well, the `Key` in the pair may comes from an external type, in my case, I have to put my external dll in the same directory of the script, the script will try to import these dll files.

```
The following exception occurred while trying to enumerate the collection: "Unable to find assembly 'xxxxxxx, Version=1.0.0.0, Culture=neutral, 
PublicKeyToken=null'.".
```

