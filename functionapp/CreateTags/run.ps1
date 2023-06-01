param($eventGridEvent, $TriggerMetadata)

$eventGridEvent | ConvertTo-Json -Depth 20

$resId = $eventGridEvent.subject
try {
    $tags = (Get-AzTag -ResourceId $resId).Properties.TagsProperty
}
catch {
    Write-Host "Tags not supported for resource: $resId"
    exit
}

$createdBy = $eventGridEvent.data.claims.name ?? ""
$createdOn = (Get-Date -f "yyyy-MM-dd")
if($tags.Count -eq 0) {
    $tags += @{"CreatedBy" = $createdBy}
    $tags += @{"CreatedOn" = (Get-Date -f "yyyy-MM-dd")}
    New-AzTag -ResourceId $resId -Tag $tags
} else {
    $hasChanges = $false

    if($null -eq $tags["CreatedBy"]) {
        Write-Host "Adding CreatedBy tag with value of: $createdBy"
        $tags += @{"CreatedBy" = $createdBy}
        $hasChanges = $true
    }
    
    if($null -eq $tags["CreatedOn"]) {
        Write-Host "Adding CreatedOn tag with value of: $createdOn"
        $tags += @{"CreatedOn" = $createdOn}
        $hasChanges = $true
    }
    
    if($hasChanges){
        Update-AzTag -ResourceId $resId -Tag $tags -Operation Merge
    }
}