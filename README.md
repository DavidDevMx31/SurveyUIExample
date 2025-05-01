# SurveyUI

Este es un proyecto muestra de un package para insertar encuestas de usuario en aplicaciones iOS.

## Estructura del proyecto
La carpeta *SurveyExample* contiene el proyecto principal. En este proyecto se puede hacer la configuración inicial del módulo de encuestas. El package de Survey ya contiene una configuración por defecto, pero esta se puede sobreescribir creando un objeto que conforme con el protocolo *SurveyTheme*.

### SurveyTheme
Al conformar con este protocolo, se pueden establecer los valores para las siguientes propiedades:

| Nombre de la propiedad | Tipo de dato | Descripción |
| ------------- | ------------- |  ------------- |
| backgroundColor  | Color  | El color de fondo de las vistas en el módulo Survey |
| foregroundColor  | Color  | El color del texto del módulo Survey |
| surveyIntroFont  | Font  | La fuente del texto de introducción a la encuesta |
| questionFont  | Font  | La fuente para el texto de las preguntas |
| calloutFont  | Font  | La fuente del texto de alertas |
| bodyFont  | Font  | La fuente del resto de los textos |
| optionBackgroundColor  | Color  | El color de fondo del recuadro con opciones para las preguntas |
| unselectedOptionForegroundColor  | Color  | El color del texto de las opciones para la pregunta (cuando no ha sido seleccionado) |
| selectedOptionForegroundColor  | Color  | El color del texto de las opciones para la pregunta (cuando está seleccionado) |

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
| Nombre de la propiedad | Tipo de dato | Descripción |
| ------------- | ------------- |  ------------- |
| Intro | String | Texto que se mostrará al usuario como una breve introducción (opcional)
| Acknowledgments | String | Texto que mostrará al usuario al completar la encuesta
| Questions | Question | Un array con las preguntas de la encuesta
