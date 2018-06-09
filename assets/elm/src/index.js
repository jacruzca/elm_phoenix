import './main.css';
import { Signup } from './Signup.elm';
import registerServiceWorker from './registerServiceWorker';

Signup.embed(document.getElementById('root'));

registerServiceWorker();
