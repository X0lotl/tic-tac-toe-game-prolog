import PrimeVue from "primevue/config";
import ToastService from "primevue/toastservice";
import ConfirmationService from "primevue/confirmationservice";
import Tooltip from "primevue/tooltip";

export default defineNuxtPlugin(({ vueApp }) => {
  vueApp.use(PrimeVue, { ripple: true });
  vueApp.use(ToastService);
  vueApp.use(ConfirmationService);
  vueApp.directive("tooltip", Tooltip);
});