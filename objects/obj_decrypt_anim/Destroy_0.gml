///@desc Free surfaces
for (var ff=0;ff<array_length(surf);ff++)
    {
    if surface_exists(surf[ff]) then surface_free(surf[ff]);
    }