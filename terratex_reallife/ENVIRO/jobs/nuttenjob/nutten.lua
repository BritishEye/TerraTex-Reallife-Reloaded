-- vioGetElementData(thePlayer,"lastHouse")

function sex_func(thePlayer, cmd, toPlayerName)
    if (toPlayerName) then
        local toPlayer = getPlayerFromIncompleteName(toPlayerName)
        if (toPlayer) then
            if (thePlayer ~= toPlayer) then
                if (vioGetElementData(thePlayer, "job") == 16) then
                    if (vioGetElementData(thePlayer, "lastHouse") or arePlayersInSameVehicle(thePlayer, toPlayer)) then
                        local p1x, p1y, p1z = getElementPosition(thePlayer)
                        local p2x, p2y, p2z = getElementPosition(toPlayer)
                        if (getDistanceBetweenPoints3D(p1x, p1y, p1z, p2x, p2y, p2z) < 5) then
                            setElementData(toPlayer, "sexAngebotVon", thePlayer)
                            outputChatBox(string.format("Die Nutte %s hat dir Sex angeboten! (annehmen mit '/accept sex')", getPlayerName(thePlayer)), toPlayer)
                            outputChatBox(string.format("Du hast dem Spieler %s Sex angeboten!", getPlayerName(toPlayer)), thePlayer)
                        else
                            showError(thePlayer, "Ihr beide seit nicht beeinander!")
                        end
                    else
                        showError(thePlayer, "Sie müssen in einen Fahrzeug sein oder in einem Haus um Sex zu haben!")
                    end
                elseif (vioGetElementData(toPlayer, "DBID") == vioGetElementData(thePlayer, "verheiratet")) then
                    if (vioGetElementData(thePlayer, "lastHouse") or arePlayersInSameVehicle(thePlayer, toPlayer)) then
                        local p1x, p1y, p1z = getElementPosition(thePlayer)
                        local p2x, p2y, p2z = getElementPosition(toPlayer)
                        if (getDistanceBetweenPoints3D(p1x, p1y, p1z, p2x, p2y, p2z) < 5) then
                            setElementData(toPlayer, "sexAngebotVon", thePlayer)
                            outputChatBox(string.format("Dein Ehepartner %s hat dir Sex angeboten! (annehmen mit '/accept sex')", getPlayerName(thePlayer)), toPlayer)
                            outputChatBox(string.format("Du hast deinem Ehepartner %s Sex angeboten!", getPlayerName(toPlayer)), thePlayer)
                        else
                            showError(thePlayer, "Ihr beide seit nicht beeinander!")
                        end
                    else
                        showError(thePlayer, "Sie müssen in einen Fahrzeug sein oder in einem Haus um Sex zu haben!")
                    end
                else
                    showError(thePlayer, "Du kannst kein Sex mit dieser Person haben!")
                end
            else
                showError(thePlayer, "Selbstbefriedigung ist zwar schön, befriedigt aber nicht so toll wie Sex mit einem Partner.\nSuch dir einen Partner.")
            end
        else
            showError(thePlayer, "Dieser Spieler existiert nicht!")
        end
    else
        showError(thePlayer, "Usage: /sex [Spielername]")
    end
end

addCommandHandler("sex", sex_func, false, false)

function arePlayersInSameVehicle(thePlayer, toPlayer)
    if (isPedInVehicle(thePlayer) and isPedInVehicle(toPlayer)) then
        if (getPedOccupiedVehicle(thePlayer) == getPedOccupiedVehicle(toPlayer)) then
            return true
        else
            return false
        end
    else
        return false
    end
end

function accept_sex(thePlayer)
    if (vioGetElementData(thePlayer, "sexAngebotVon")) then
        local toPlayer = vioGetElementData(thePlayer, "sexAngebotVon")
        if (toPlayer) then
            local p1x, p1y, p1z = getElementPosition(thePlayer)
            local p2x, p2y, p2z = getElementPosition(toPlayer)
            if (vioGetElementData(toPlayer, "job") == 16) then
                if (isPlayerInAnyHouse(thePlayer) or arePlayersInSameVehicle(thePlayer, toPlayer)) then
                    local p1x, p1y, p1z = getElementPosition(thePlayer)
                    local p2x, p2y, p2z = getElementPosition(toPlayer)
                    if (getDistanceBetweenPoints3D(p1x, p1y, p1z, p2x, p2y, p2z) < 5) then
                        setElementData(thePlayer, "sexAngebotVon", false)
                        local usedKondom = false
                        if (vioGetElementData(thePlayer, "Kondome") > 0) then
                            vioSetElementData(thePlayer, "Kondome", vioGetElementData(thePlayer, "Kondome") - 1)
                            usedKondom = true
                        elseif (vioGetElementData(toPlayer, "Kondome") > 0) then
                            vioSetElementData(toPlayer, "Kondome", vioGetElementData(toPlayer, "Kondome") - 1)
                            usedKondom = true
                        end
                        if (usedKondom or math.random(1, 2) ~= 2) then
                            triggerClientEvent(thePlayer, "stopFoodTimerForSeconds", thePlayer, 300)
                            triggerClientEvent(toPlayer, "stopFoodTimerForSeconds", toPlayer, 300)
                            local hp = getElementHealth(thePlayer)
                            if hp > 50 then hp = 100 else hp = hp +50 end
                            setElementHealth(thePlayer, hp )

                            hp = getElementHealth(toPlayer)
                            if hp > 50 then hp = 100 else hp = hp +50 end
                            setElementHealth(toPlayer, hp )

                            outputChatBox("Ihr hattet gerade Sex und seid so gut drauf, dass ihr nun 5 Minuten nichts essen müsst!", thePlayer, 0, 255, 0)
                            outputChatBox("Ihr hattet gerade Sex und seid so gut drauf, dass ihr nun 5 Minuten nichts essen müsst!", toPlayer, 0, 255, 0)
                        else
                            triggerClientEvent(thePlayer, "krankheitsreduce", thePlayer)
                            triggerClientEvent(toPlayer, "krankheitsreduce", toPlayer)
                            if (getElementHealth(thePlayer) > 25) then setElementHealth(thePlayer, 25) end
                            if (getElementHealth(toPlayer) > 25) then setElementHealth(toPlayer, 25) end
                            outputChatBox("Da ihr keine Kondome hattet, habt ihr eine Geschlechtskrankheit bekommen!", thePlayer, 0, 255, 0)
                            outputChatBox("Da ihr keine Kondome hattet, habt ihr eine Geschlechtskrankheit bekommen!", toPlayer, 0, 255, 0)
                        end
                        if not (arePlayersInSameVehicle(thePlayer, toPlayer)) then
                            local x, y, z = getElementPosition(toPlayer)
                            setElementPosition(thePlayer, x, y, z)
                            local rx, ry, rz = getElementRotation(toPlayer)
                            setElementRotation(thePlayer, rx, ry, rz)
                            setPedAnimation(thePlayer, "sex", "sex_1_cum_w", 1, true, false)
                            setPedAnimation(toPlayer, "sex", "sex_1_cum_p", 1, true, false)
                            vioSetElementData(toPlayer, "anim", 1)
                            bindKey(toPlayer, "space", "down", stopanima)
                            showtext(toPlayer)

                            vioSetElementData(thePlayer, "anim", 1)
                            bindKey(thePlayer, "space", "down", stopanima)
                            showtext(thePlayer)
                        end
                    else
                        showError(thePlayer, "Ihr beide seit nicht beeinander!")
                    end
                else
                    showError(thePlayer, "Sie müssen in einen Fahrzeug sein oder in einem Haus um Sex zu haben!")
                end
            elseif (vioGetElementData(toPlayer, "DBID") == vioGetElementData(thePlayer, "verheiratet")) then
                if (isPlayerInAnyHouse(thePlayer) or arePlayersInSameVehicle(thePlayer, toPlayer)) then

                    if (getDistanceBetweenPoints3D(p1x, p1y, p1z, p2x, p2y, p2z) < 5) then
                        setElementData(thePlayer, "sexAngebotVon", false)
                        local usedKondom = false
                        if (vioGetElementData(thePlayer, "Kondome") > 0) then
                            vioSetElementData(thePlayer, "Kondome", vioGetElementData(thePlayer, "Kondome") - 1)
                            usedKondom = true
                        elseif (vioGetElementData(toPlayer, "Kondome") > 0) then
                            vioSetElementData(toPlayer, "Kondome", vioGetElementData(toPlayer, "Kondome") - 1)
                            usedKondom = true
                        end
                        if (usedKondom or math.random(1, 4) ~= 2) then
                            triggerClientEvent(thePlayer, "stopFoodTimerForSeconds", thePlayer, 300)
                            triggerClientEvent(toPlayer, "stopFoodTimerForSeconds", toPlayer, 300)

                            triggerClientEvent(thePlayer, "addFood", thePlayer, 50)
                            triggerClientEvent(toPlayer, "addFood", toPlayer, 50)

                            outputChatBox("Ihr hattet gerade Sex und seid so gut drauf, dass ihr nun 5 Minuten nichts essen müsst!", thePlayer, 0, 255, 0)
                            outputChatBox("Ihr hattet gerade Sex und seid so gut drauf, dass ihr nun 5 Minuten nichts essen müsst!", toPlayer, 0, 255, 0)
                        else
                            local kosten = math.random(400, 1500)
                            changePlayerMoney(thePlayer, -kosten, "sonstiges", "Kindergeld (Sex)")
                            changePlayerMoney(toPlayer, -kosten, "sonstiges", "Kindergeld (Sex)")
                            outputChatBox(string.format("Ihr habt ein Kind gezeugt! Die Kosten haben sich auf %s für jeden von euch belaufen!", toprice(kosten)), thePlayer)
                            outputChatBox(string.format("Ihr habt ein Kind gezeugt! Die Kosten haben sich auf %s für jeden von euch belaufen!", toprice(kosten)), toPlayer)
                        end
                        if not (arePlayersInSameVehicle(thePlayer, toPlayer)) then
                            local x, y, z = getElementPosition(toPlayer)
                            setElementPosition(thePlayer, x, y, z)
                            local rx, ry, rz = getElementRotation(toPlayer)
                            setElementRotation(thePlayer, rx, ry, (180 - rz))
                            setPedAnimation(thePlayer, "sex", "sex_1_cum_w", 1, true, false)
                            setPedAnimation(toPlayer, "sex", "sex_1_cum_p", 1, true, false)
                            vioSetElementData(toPlayer, "anim", 1)
                            bindKey(toPlayer, "space", "down", stopanima)
                            showtext(toPlayer)

                            vioSetElementData(thePlayer, "anim", 1)
                            bindKey(thePlayer, "space", "down", stopanima)
                            showtext(thePlayer)
                        end
                    else
                        showError(thePlayer, "Ihr beide seit nicht beeinander!")
                    end
                else
                    showError(thePlayer, "Sie müssen in einen Fahrzeug sein oder in einem Haus um Sex zu haben!")
                end
            else
                showError(thePlayer, "Du kannst kein Sex mit dieser Person haben!")
            end
        else
            showError(thePlayer, "Dir wurde kein Sex angeboten!")
        end
    else
        showError(thePlayer, "Dir wurde kein Sex angeboten!")
    end
end
registerAcceptHandler("sex", accept_sex, {
    requestedDataValues = {"sexAngebotVon"}
});






