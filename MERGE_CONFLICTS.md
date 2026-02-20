# PR no mergeable: "La rama tiene conflictos de fusión"

Este error **no es de la app** (cámara/cronómetro), es de GitHub: tu rama y la rama base cambiaron las mismas líneas.

## Solución rápida (desde local)

## Solución automática (recomendada en este repo)

Puedes usar el script incluido para reconstruir tu rama encima de `origin/main` y re-aplicar tus commits:

```bash
git checkout <tu-rama>
scripts/fix_pr_conflicts.sh main
git push --force-with-lease origin <tu-rama>
```

Si durante el `cherry-pick` aparece conflicto en `app.js` o `index.html`, el script lo auto-resuelve conservando tu versión del PR (`--theirs`). Si hay conflictos en otros archivos, se para y te indica cómo continuar manualmente.

1. Trae la base más reciente:

```bash
git fetch origin
```

2. Rebase de tu rama contra `main`:

```bash
git checkout <tu-rama>
git rebase origin/main
```

3. Si hay conflictos, abre los archivos marcados y resuelve los bloques:

```text
<<<<<<< HEAD
(cambios de main)
=======
(cambios de tu rama)
>>>>>>> <commit>
```

4. Marca resuelto y continúa:

```bash
git add app.js index.html
git rebase --continue
```

5. Sube la rama reescrita:

```bash
git push --force-with-lease
```

Después de eso, el PR debería pasar de **"not mergeable"** a **mergeable**.

## Alternativa en GitHub (web)

- En el PR, pulsa **Resolve conflicts**.
- Elige el contenido final en `app.js` / `index.html`.
- Marca **Resolved** y luego **Commit merge**.

## Nota para este repo

Los conflictos suelen caer en `app.js` e `index.html` porque concentran la mayoría de cambios de UI y lógica.

## Caso exacto de tu captura (conflicto en `app.js` y no deja guardar)

Si GitHub te muestra conflicto en la zona de `loginWithTech`, `doLogin` y `btnGuestAccess`, **pega este bloque final completo** (tal cual) y elimina todo marcador `<<<<<<< ======= >>>>>>>`:

```js
async function loginWithTech(name){
  const safeName = String(name || "").trim().slice(0, 18);
  if (!safeName) return toast("Escribe el nombre de acceso.");
  state.tech = safeName;
  localStorage.setItem("isivolt.tech", safeName);
  $("techName").value = safeName;
  $("techPass").value = "";
  show("home");
  updateAccessHintUI();
  await refreshOT();
}

async function doLogin(){
  const name = getTechNameFromUI();
  const pass = getPassFromUI();
  const access = getStoredAccess();
  const expectedName = String(access.name || "").trim();
  const expectedPass = String(access.pass || "").trim();
  if (!name || !pass) return toast("Escribe usuario y contraseña.");
  if (name !== expectedName || pass !== expectedPass) {
    return toast("Usuario o contraseña incorrectos.");
  }
  await loginWithTech(name);
}

$("btnSetTech").addEventListener("click", async ()=>{
  await doLogin();
});
$("techName").addEventListener("keydown", async (e)=>{
  if (e.key === "Enter") await doLogin();
});
$("techPass").addEventListener("keydown", async (e)=>{
  if (e.key === "Enter") await doLogin();
});
$("btnGuestAccess").addEventListener("click", async ()=>{
  const access = getStoredAccess();
  await loginWithTech(access.name || DEFAULT_ACCESS.name);
  toast(`Acceso rápido activo: ${access.name || DEFAULT_ACCESS.name}`);
});
```

En el editor de conflictos de GitHub:
- Para esos bloques, usa **Accept current change** (rama del PR), no **Accept both**.
- Verifica que no queden marcadores `<<<<<<<`, `=======`, `>>>>>>>` en ninguna parte del archivo.
- Si sigue fallando al guardar, revisa que no hayan quedado dos funciones con el mismo nombre (`doLogin`, `loginWithTech`) pegadas dos veces.
- Haz **Mark as resolved** y luego **Commit merge**.
