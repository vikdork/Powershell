$mailboxDatabases = Get-MailboxDatabase -Status | select-object databasesize, name
$result = @()

foreach ($database in $mailboxDatabases)
{
    $result += New-Object psobject -Property @{
                                    'Database' = $database.name
                                    'Databassize' = $database.DatabaseSize.Split(" GB")[0]
                                    'Date' = get-date -f d
                                    }
}