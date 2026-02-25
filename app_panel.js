
// Datos de ejemplo para guardia móvil y técnicos
document.addEventListener('DOMContentLoaded', function() {
    const guardiaMobileContent = document.getElementById('guardia-mobile-content');
    const techniciansContainer = document.getElementById('technicians');

    // Datos de guardia móvil
    const guardiaMobileData = {
        'M': 'SERGIO IVÁN RAEZ MARTÍNEZ',
        'T': 'SINUHE BAILÓN BAILÓN',
        'N': 'CARLOS GARCÍA ESPINOSA'
    };

    // Mostrar datos de guardia móvil
    Object.entries(guardiaMobileData).forEach(([turno, nombre]) => {
        guardiaMobileContent.innerHTML += `<p><strong>${turno}:</strong> ${nombre}</p>`;
    });

    // Datos de técnicos
    const techniciansData = [
        {
            name: 'SERGIO IVÁN RAEZ MARTÍNEZ',
            shifts: { 'L': 'M', 'MA': 'M', 'MI': 'M', 'J': 'M', 'V': 'M', 'S': 'D', 'D': '-' },
            phone: 'Sin teléfono',
            load: '0h',
            tasks: []
        },
        {
            name: 'SINUHE BAILÓN BAILÓN',
            shifts: { 'L': 'M', 'MA': 'T', 'MI': 'N', 'J': 'D', 'V': 'M', 'S': 'D', 'D': '-' },
            phone: 'Sin teléfono',
            load: '0h',
            tasks: []
        }
        // Añadir más técnicos según sea necesario
    ];

    // Mostrar técnicos
    techniciansData.forEach(technician => {
        const card = document.createElement('div');
        card.className = 'col-md-6 col-lg-4';

        const shiftsHTML = Object.entries(technician.shifts).map(([day, shift]) =>
            `<div class="col-4 mb-2"><small><strong>${day}:</strong> ${shift}</small></div>`).join('');

        card.innerHTML = `
            <div class="card shift-card">
                <div class="card-body">
                    <h5 class="card-title">${technician.name}</h5>
                    <p class="card-text"><small>☎ ${technician.phone} · ${Object.values(technician.shifts)[0]} · Mañana</small></p>
                    <p class="card-text"><small>Carga: <strong>${technician.load}</strong></small></p>
                    <div class="row">${shiftsHTML}</div>
                    <p class="card-text mt-2"><small>Sin tareas extra</small></p>
                </div>
            </div>
        `;
        techniciansContainer.appendChild(card);
    });
});
