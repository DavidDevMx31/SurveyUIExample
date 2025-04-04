# SurveyUI

Este es un proyecto muestra de un paquete para insertar encuestas de usuario en aplicaciones de iOS.

## Estructura del proyecto
La carpeta *SurveyExample* contiene el proyecto principal. En este proyecto se puede hacer la configuración inicial del módulo de encuestas. El package de Survey ya contiene una configuración por defecto, pero esta se puede sobreescribir creando un objeto que conforme con el protocolo *SurveyTheme*.

### SurveyTheme
Al conformar con este protocolo, se pueden establecer los valores para las siguientes propiedades:

- **backgroundColor**: define el color de fondo del módulo Survey.
- **foregroundColor**: define el color de letra del módulo Survey.

El código contiene un ejemplo de cómo se puede inyectar un estilo personalizado al paquete *Survey*.

En el archivo *SurveyExampleApp* se puede ver un ejemplo de la inyección de un estilo personalizado para la interfaz de encuestas.


## Encuestas de usuario
El punto de acceso a la interfaz de usuario del package *SurveyUI* es por medio de la vista **SurveyView**.

### SurveyView
Para inicializar esta vista se requieren dos parámetros: 
- **Survey**: los datos de la encuesta que se va a presentar.
- **onCompleted**: un closure que recibirá como entrada los resultados de la encuesta.

### Survey
Survey define el modelo de las encuestas. Consta de las siguientes propiedades:

- **Intro** (String): texto que se mostrará al usuario como una breve introducción. (opcional).
- **Acknowledgments**(String): texto que mostrará al usuario al completar la encuesta.
- **Questions**: un array con las preguntas de la encuesta.
