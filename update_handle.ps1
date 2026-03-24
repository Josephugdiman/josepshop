$path = 'src\pages\Dashboard.jsx'
$content = [System.IO.File]::ReadAllText((Resolve-Path $path))

# Fix encoding issues first (broadly)
$content = $content.Replace('Ã¢Å“â€¦', '✅')

# Identify the old handleUpdateVendor function
# Use single-quoted heredoc to avoid expansion of $ in JS
$newFunc = @'
  const handleUpdateVendor = async () => {
    if (!selectedVendor) return
    try {
      const headers = getAuthHeaders()
      if (!headers) {
        throw new Error('No authentication token available. Please login first.')
      }

      const currentYear = new Date().getFullYear();
      let occupationHistory = [];
      let paymentHistory = [];

      try {
        occupationHistory = typeof selectedVendor.occupation_history === 'string' 
          ? JSON.parse(selectedVendor.occupation_history) 
          : (selectedVendor.occupation_history || []);
        paymentHistory = typeof selectedVendor.payment_history === 'string' 
          ? JSON.parse(selectedVendor.payment_history) 
          : (selectedVendor.payment_history || []);
      } catch (e) {
        console.error("Error parsing history:", e);
      }

      const updateData = {
        business_name: newVendorForm.business_name,
        owner_name: newVendorForm.owner_name,
        business_type: newVendorForm.business_type,
        email: newVendorForm.email,
        phone: newVendorForm.contact_number,
        address: newVendorForm.address,
        stall_number: newVendorForm.stall_number,
        section: newVendorForm.section,
        section_id: newVendorForm.section_id,
        block: newVendorForm.block,
        section_type: newVendorForm.section_type,
        floor: newVendorForm.floor,
        registration_date: newVendorForm.registration_date,
        status: newVendorForm.status,
        application_type: newVendorForm.permit_type,
        permit_type: newVendorForm.permit_type,
        yearly_fee: newVendorForm.yearly_fee,
        current_balance: newVendorForm.current_balance,
        total_balance: newVendorForm.total_balance,
        business_start_year: newVendorForm.business_start_year,
        business_end_year: newVendorForm.business_end_year,
        vendor_type: newVendorForm.vendor_type
      }

      // If this is a renewal update, update/append to histories
      if (newVendorForm.vendor_type === "renew") {
        const existingPayIdx = paymentHistory.findIndex(p => p.year === currentYear);
        const newPayment = {
          year: currentYear,
          amount_paid: newVendorForm.yearly_fee - newVendorForm.current_balance,
          amount_due: newVendorForm.current_balance,
          status: newVendorForm.current_balance > 0 ? "partial" : "paid"
        };
        if (existingPayIdx >= 0) paymentHistory[existingPayIdx] = newPayment;
        else paymentHistory.push(newPayment);

        const existingOccIdx = occupationHistory.findIndex(o => o.year_start === currentYear || o.year_end === currentYear);
        if (existingOccIdx >= 0) {
          occupationHistory[existingOccIdx].year_end = currentYear;
          occupationHistory[existingOccIdx].status = "active";
        } else {
          occupationHistory.push({
            year_start: currentYear,
            year_end: currentYear,
            status: "active"
          });
        }
        
        updateData.occupation_history = occupationHistory;
        updateData.payment_history = paymentHistory;
      }

      if (newVendorForm.stall_number !== selectedVendor.stall_number) {
        const isStallOccupied = allVendors.some(v =>
          v.id !== selectedVendor.id && v.stall_number === newVendorForm.stall_number
        );
       
        if (isStallOccupied) {
          alert(`Stall ${newVendorForm.stall_number} is already occupied. Please select a different stall.`);
          return;
        }
      }

      const response = await fetch(`${API_URL}/vendors/${selectedVendor.id}`, {
        method: 'PUT',
        headers: headers,
        body: JSON.stringify(updateData)
      })

      if (response.status === 401) {
        logout()
        alert('Session expired. Please login again.')
        return
      }

      if (!response.ok) {
        const errorData = await response.json()
        throw new Error(errorData.message || 'Failed to update vendor')
      }

      const updatedVendors = allVendors.map(v =>
        v.id === selectedVendor.id ? {
          ...v,
          ...updateData,
          contact_number: newVendorForm.contact_number,
          phone: newVendorForm.contact_number,
          occupation_history: occupationHistory,
          payment_history: paymentHistory
        } : v
      )
      
      setAllVendors(updatedVendors)
      setIsEditingVendor(false)
      setSelectedVendor(null)
      resetNewVendorForm()
      fetchDashboardData()
      alert('✅ Vendor updated successfully!')
    } catch (error) {
      console.error('Error updating vendor:', error.message)
      alert('Failed to update vendor: ' + error.message)
    }
  }
'@

$oldFuncStart = '  const handleUpdateVendor = async () => {'
$startIndex = $content.IndexOf($oldFuncStart)
if ($startIndex -ge 0) {
    # Find the end of the function (until handleRenewVendor or handleDeleteVendor)
    $endIndex = $content.IndexOf("  const handleRenewVendor", $startIndex)
    if ($endIndex -lt 0) {
        $endIndex = $content.IndexOf("  const handleDeleteVendor", $startIndex)
    }
    
    if ($endIndex -gt $startIndex) {
        $newContent = $content.Substring(0, $startIndex) + $newFunc + "`r`n`r`n" + $content.Substring($endIndex)
        [System.IO.File]::WriteAllText((Resolve-Path $path), $newContent)
        Write-Host "SUCCESS_UPDATE_HANDLE"
    } else {
        Write-Host "FAILED_TO_FIND_FUNC_END"
    }
} else {
    Write-Host "FAILED_TO_FIND_FUNC_START"
}
