# Procedencia y selección de versiones

Autores del trabajo académico: Miguel Pajuelo Gómez y Jorge Ois de Pascual. Las cabeceras originales de los scripts se conservan.

Se usan los scripts de instalación y despliegue de la entrega descomprimida y los de procesamiento y cliente de la carpeta de trabajo. `stats_checker`, `topn_selection` y el apartado 3 coinciden entre trabajo y entrega. Para el apartado 4 se elige trabajo porque utiliza `model` y `metodo`, coherentes con el endpoint externo y la función de reintento; la entrega contiene `modelo` y una llamada con `method` incompatible con esa función.

En las copias se han hecho ajustes de shell, rutas, entorno virtual, IP y puerto. No se han cambiado los algoritmos de estadísticas, selección ni el esquema de peticiones de la versión elegida. Las figuras y los PDF se copian íntegros. Las variantes Word y los ZIP permanecen en el archivo original de la asignatura.

El despliegue depende de [pablosanchezp/ProyectoFUSO](https://github.com/pablosanchezp/ProyectoFUSO). Su rama `main` se comprobó el 6 de octubre de 2026 en el commit `53d028b72a5195e700c04d28c0a448914b6b924d`. El servidor, las plantillas, el modelo y los generadores de mapas son una dependencia externa, no código nuevo de este repositorio. La descarga del framework se realiza al preparar el despliegue; no se ha incorporado su código a esta carpeta.

Los scripts conservan la referencia al dataset docente de Gowalla. [SNAP](https://snap.stanford.edu/data/loc-Gowalla.html) atribuye el dataset original a E. Cho, S. A. Myers y J. Leskovec, *Friendship and Mobility*, KDD 2011. Las cuatro distribuciones por ciudad no se han reconstruido desde el dataset completo.
