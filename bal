
-- === BALANCE DISPLAY ===
local lastBalances = {}
local showBalances = false
 
local function listenForBalances()
    while true do
        local sender, msg = rednet.receive()
        if type(msg) == "table" and msg.action == "top_balances" and type(msg.entries) == "table" then
            local sorted = {}
            for _, entry in ipairs(msg.entries) do
                local bal = tonumber(entry.balance) or 0
                if bal >= 0 then
                    table.insert(sorted, {name = entry.name, balance = bal})
                end
            end
 
            table.sort(sorted, function(a, b) return a.balance > b.balance end)
            lastBalances = sorted
 
            if showBalances then
                local display = "Top Balances:\n"
                for i, entry in ipairs(sorted) do
                    local line = i .. ") " .. entry.name .. ": " .. formatBalance(entry.balance) .. "\n"
                    if #display + #line > 512 then break end
                    display = display .. line
                end
                balanceText.setText(display)
            end
        end
    end
end
