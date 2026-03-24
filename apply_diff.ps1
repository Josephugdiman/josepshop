$path = 'src\pages\Dashboard.jsx'
$content = Get-Content $path -Raw
$newFunc = @"
  const handleRenewVendor = (vendor) => {
    setSelectedVendor(vendor)
    const currentYear = new Date().getFullYear().toString()
    setNewVendorForm({
      business_name: vendor.business_name || "",
      owner_name: vendor.owner_name || "",
      business_type: vendor.business_type || "",
      stall_number: vendor.stall_number || "",
      section: vendor.section || "",
      section_id: vendor.section_id || "",
      block: vendor.block || "",
      floor: vendor.floor || "Ground Floor",
      contact_number: vendor.contact_number || vendor.phone || "",
      email: vendor.email || "",
      status: "active",
      permit_type: vendor.permit_type || vendor.application_type || "regular",
      yearly_fee: vendor.yearly_fee || getDefaultYearlyFee(vendor.section_type),
      current_balance: vendor.yearly_fee || 0,
      total_balance: (vendor.current_balance || 0) + (vendor.yearly_fee || 0),
      registration_date: new Date().toISOString().split('T')[0],
      address: vendor.address || "",
      section_type: vendor.section_type || "",
      business_start_year: vendor.business_start_year || currentYear,
      business_end_year: currentYear,
      vendor_type: "renew"
    })
   
    if (vendor.section_id) {
      const stalls = getAvailableStallsForSection(vendor.section_id, allVendors.filter(v => v.id !== vendor.id));
      setAvailableStalls(stalls);
    }
   
    setIsEditingVendor(true)
  }

"@

$target = '  const handleDeleteVendor = async (vendorId) => {'
if ($content.Contains($target)) {
    $newContent = $content.Replace($target, $newFunc + $target)
    [System.IO.File]::WriteAllText((Resolve-Path $path), $newContent)
    Write-Host "SUCCESS_RENEW_FUNC"
} else {
    Write-Host "FAILED_TO_FIND_TARGET"
    # Try with different spacing
    $target2 = 'const handleDeleteVendor = async (vendorId) => {'
    if ($content.Contains($target2)) {
         $newContent = $content.Replace($target2, $newFunc + $target2)
         [System.IO.File]::WriteAllText((Resolve-Path $path), $newContent)
         Write-Host "SUCCESS_RENEW_FUNC_V2"
    }
}

# Now for the button
$content = Get-Content $path -Raw
$newButton = @"
            <button
              onClick={(e) => {
                e.stopPropagation();
                handleRenewVendor(row);
              }}
              className={`p-1.5 transition hover:bg-slate-700/50 rounded ${new Date().getMonth() === 0 ? 'text-emerald-500 bg-emerald-500/10 animate-pulse' : 'text-slate-400 hover:text-emerald-400'}`}
              title="Renew Vendor"
            >
              <RotateCcw className="w-4 h-4" />
            </button>
"@

$targetButton = '            <button
              onClick={(e) => {
                e.stopPropagation();
                handleDeleteVendor(row.id);
              }}'

if ($content.Contains($targetButton)) {
    $newContent = $content.Replace($targetButton, $newButton + $targetButton)
    [System.IO.File]::WriteAllText((Resolve-Path $path), $newContent)
    Write-Host "SUCCESS_BUTTON"
} else {
    Write-Host "FAILED_TO_FIND_BUTTON"
}
