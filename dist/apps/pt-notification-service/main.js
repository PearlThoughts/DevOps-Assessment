/******/ (() => { // webpackBootstrap
/******/ 	"use strict";
/******/ 	var __webpack_modules__ = ([
/* 0 */,
/* 1 */
/***/ ((module) => {

module.exports = require("@nestjs/common");

/***/ }),
/* 2 */
/***/ ((module) => {

module.exports = require("@nestjs/core");

/***/ }),
/* 3 */
/***/ ((__unused_webpack_module, exports, __webpack_require__) => {


Object.defineProperty(exports, "__esModule", ({ value: true }));
exports.AppModule = void 0;
const tslib_1 = __webpack_require__(4);
const common_1 = __webpack_require__(1);
const config_1 = __webpack_require__(5);
const app_controller_1 = __webpack_require__(6);
const app_service_1 = __webpack_require__(7);
const notifme_module_1 = __webpack_require__(8);
const notification_module_1 = __webpack_require__(11);
const environment_1 = tslib_1.__importDefault(__webpack_require__(15));
let AppModule = class AppModule {
};
exports.AppModule = AppModule;
exports.AppModule = AppModule = tslib_1.__decorate([
    (0, common_1.Module)({
        imports: [config_1.ConfigModule.forRoot({
                load: [environment_1.default],
                isGlobal: true,
            }), notifme_module_1.NotifmeModule, notification_module_1.NotificationModule],
        controllers: [app_controller_1.AppController],
        providers: [app_service_1.AppService]
    })
], AppModule);


/***/ }),
/* 4 */
/***/ ((module) => {

module.exports = require("tslib");

/***/ }),
/* 5 */
/***/ ((module) => {

module.exports = require("@nestjs/config");

/***/ }),
/* 6 */
/***/ ((__unused_webpack_module, exports, __webpack_require__) => {


var _a;
Object.defineProperty(exports, "__esModule", ({ value: true }));
exports.AppController = void 0;
const tslib_1 = __webpack_require__(4);
const common_1 = __webpack_require__(1);
const app_service_1 = __webpack_require__(7);
let AppController = class AppController {
    constructor(appService) {
        this.appService = appService;
    }
    getHello() {
        return this.appService.getHello();
    }
};
exports.AppController = AppController;
tslib_1.__decorate([
    (0, common_1.Get)(),
    tslib_1.__metadata("design:type", Function),
    tslib_1.__metadata("design:paramtypes", []),
    tslib_1.__metadata("design:returntype", String)
], AppController.prototype, "getHello", null);
exports.AppController = AppController = tslib_1.__decorate([
    (0, common_1.Controller)(),
    tslib_1.__metadata("design:paramtypes", [typeof (_a = typeof app_service_1.AppService !== "undefined" && app_service_1.AppService) === "function" ? _a : Object])
], AppController);


/***/ }),
/* 7 */
/***/ ((__unused_webpack_module, exports, __webpack_require__) => {


Object.defineProperty(exports, "__esModule", ({ value: true }));
exports.AppService = void 0;
const tslib_1 = __webpack_require__(4);
const common_1 = __webpack_require__(1);
let AppService = class AppService {
    getHello() {
        return 'bye byes!';
    }
};
exports.AppService = AppService;
exports.AppService = AppService = tslib_1.__decorate([
    (0, common_1.Injectable)()
], AppService);


/***/ }),
/* 8 */
/***/ ((__unused_webpack_module, exports, __webpack_require__) => {


Object.defineProperty(exports, "__esModule", ({ value: true }));
exports.NotifmeModule = void 0;
const tslib_1 = __webpack_require__(4);
const common_1 = __webpack_require__(1);
const notifme_service_1 = __webpack_require__(9);
let NotifmeModule = class NotifmeModule {
};
exports.NotifmeModule = NotifmeModule;
exports.NotifmeModule = NotifmeModule = tslib_1.__decorate([
    (0, common_1.Module)({
        providers: [notifme_service_1.NotifmeService],
        exports: [notifme_service_1.NotifmeService]
    })
], NotifmeModule);


/***/ }),
/* 9 */
/***/ ((__unused_webpack_module, exports, __webpack_require__) => {


var NotifmeService_1;
Object.defineProperty(exports, "__esModule", ({ value: true }));
exports.NotifmeService = void 0;
const tslib_1 = __webpack_require__(4);
const common_1 = __webpack_require__(1);
const notifme_sdk_1 = tslib_1.__importDefault(__webpack_require__(10));
let NotifmeService = NotifmeService_1 = class NotifmeService {
    constructor() {
        this.logger = new common_1.Logger(NotifmeService_1.name);
        this.customRetryFallbackStrategy = (providers) => async (request) => {
            if (providers.length >= 2) {
                const primaryEmailServiceProvider = providers[0];
                const fallbackEmailServiceProvider = providers[1];
                let numberOfTries = 2;
                while (numberOfTries > 0) {
                    try {
                        const id = await primaryEmailServiceProvider.send(request);
                        return { id, providerId: primaryEmailServiceProvider.id };
                    }
                    catch (error) {
                        this.logger.error(error);
                        numberOfTries -= 1;
                    }
                }
                try {
                    const id = await fallbackEmailServiceProvider.send(request);
                    return { id, providerId: fallbackEmailServiceProvider.id };
                }
                catch (error) {
                    this.logger.error(error);
                    throw error;
                }
            }
        };
    }
    // constructor(private configService: ConfigService) {
    //   this.notifmeSdk = new NotifmeSdk({
    //     channels: {
    //       email: {
    //         providers: [
    //           {
    //             type: 'ses',
    //             region: this.configService.get('aws.region'),
    //             accessKeyId: this.configService.get('aws.access_key'),
    //             secretAccessKey: this.configService.get('aws.secret_access_key'),
    //             // sessionToken: 'xxxxx', // optional
    //           },
    //           {
    //             type: 'mailgun',
    //             apiKey: this.configService.get('mailgun.apiKey'),
    //             domainName: this.configService.get('mailgun.domainName'),
    //           },
    //         ],
    //         multiProviderStrategy: this.customRetryFallbackStrategy,
    //       },
    //     },
    //   });
    // }
    // constructor(
    //   primaryEmailProvider: EmailProvider,
    //   fallbackEmailProvider: EmailProvider,
    // ) {
    //   this.notifmeSdk = new NotifmeSdk({
    //     channels: {
    //       email: {
    //         providers: [primaryEmailProvider, fallbackEmailProvider],
    //         multiProviderStrategy: this.customRetryFallbackStrategy,
    //       },
    //     },
    //   });
    // }
    setEmailProviders(primaryEmailProvider, fallbackEmailProvider) {
        this.notifmeSdk = new notifme_sdk_1.default({
            channels: {
                email: {
                    providers: [primaryEmailProvider, fallbackEmailProvider],
                    multiProviderStrategy: this.customRetryFallbackStrategy,
                },
            },
        });
    }
    async sendEmail(emailRequest) {
        try {
            const result = await this.notifmeSdk.send({ email: emailRequest });
            return result;
        }
        catch (error) {
            this.logger.error(error);
            throw error;
        }
    }
};
exports.NotifmeService = NotifmeService;
exports.NotifmeService = NotifmeService = NotifmeService_1 = tslib_1.__decorate([
    (0, common_1.Injectable)()
], NotifmeService);


/***/ }),
/* 10 */
/***/ ((module) => {

module.exports = require("notifme-sdk");

/***/ }),
/* 11 */
/***/ ((__unused_webpack_module, exports, __webpack_require__) => {


Object.defineProperty(exports, "__esModule", ({ value: true }));
exports.NotificationModule = void 0;
const tslib_1 = __webpack_require__(4);
const common_1 = __webpack_require__(1);
const notification_service_1 = __webpack_require__(12);
const notification_controller_1 = __webpack_require__(13);
const notifme_module_1 = __webpack_require__(8);
let NotificationModule = class NotificationModule {
};
exports.NotificationModule = NotificationModule;
exports.NotificationModule = NotificationModule = tslib_1.__decorate([
    (0, common_1.Module)({
        imports: [notifme_module_1.NotifmeModule],
        controllers: [notification_controller_1.NotificationController],
        providers: [notification_service_1.NotificationService],
    })
], NotificationModule);


/***/ }),
/* 12 */
/***/ ((__unused_webpack_module, exports, __webpack_require__) => {


var NotificationService_1;
var _a;
Object.defineProperty(exports, "__esModule", ({ value: true }));
exports.NotificationService = void 0;
const tslib_1 = __webpack_require__(4);
const common_1 = __webpack_require__(1);
const notifme_service_1 = __webpack_require__(9);
let NotificationService = NotificationService_1 = class NotificationService {
    constructor(notifmeService) {
        this.notifmeService = notifmeService;
        this.logger = new common_1.Logger(NotificationService_1.name);
    }
    setEmailProviders(primaryEmailProvider, fallbackEmailProvider) {
        this.notifmeService.setEmailProviders(primaryEmailProvider, fallbackEmailProvider);
    }
    async sendEmail(emailRequest) {
        try {
            const result = await this.notifmeService.sendEmail(emailRequest);
            return result;
        }
        catch (error) {
            this.logger.error(error);
            throw error;
        }
    }
};
exports.NotificationService = NotificationService;
exports.NotificationService = NotificationService = NotificationService_1 = tslib_1.__decorate([
    (0, common_1.Injectable)(),
    tslib_1.__metadata("design:paramtypes", [typeof (_a = typeof notifme_service_1.NotifmeService !== "undefined" && notifme_service_1.NotifmeService) === "function" ? _a : Object])
], NotificationService);


/***/ }),
/* 13 */
/***/ ((__unused_webpack_module, exports, __webpack_require__) => {


var NotificationController_1;
var _a, _b;
Object.defineProperty(exports, "__esModule", ({ value: true }));
exports.NotificationController = void 0;
const tslib_1 = __webpack_require__(4);
const common_1 = __webpack_require__(1);
const notification_service_1 = __webpack_require__(12);
const email_dto_1 = __webpack_require__(14);
let NotificationController = NotificationController_1 = class NotificationController {
    constructor(notificationService) {
        this.notificationService = notificationService;
        this.logger = new common_1.Logger(NotificationController_1.name);
    }
    async sendEmail(requestBody) {
        try {
            this.notificationService.setEmailProviders(requestBody.primaryEmailProvider, requestBody.fallbackEmailProvider);
            const result = await this.notificationService.sendEmail(requestBody.emailRequest);
            this.logger.log(result);
            return result;
        }
        catch (error) {
            return error.message;
        }
    }
};
exports.NotificationController = NotificationController;
tslib_1.__decorate([
    (0, common_1.Post)('/send-email'),
    tslib_1.__param(0, (0, common_1.Body)()),
    tslib_1.__metadata("design:type", Function),
    tslib_1.__metadata("design:paramtypes", [typeof (_b = typeof email_dto_1.NewEmail !== "undefined" && email_dto_1.NewEmail) === "function" ? _b : Object]),
    tslib_1.__metadata("design:returntype", Promise)
], NotificationController.prototype, "sendEmail", null);
exports.NotificationController = NotificationController = NotificationController_1 = tslib_1.__decorate([
    (0, common_1.Controller)('notification'),
    tslib_1.__metadata("design:paramtypes", [typeof (_a = typeof notification_service_1.NotificationService !== "undefined" && notification_service_1.NotificationService) === "function" ? _a : Object])
], NotificationController);


/***/ }),
/* 14 */
/***/ ((__unused_webpack_module, exports) => {


Object.defineProperty(exports, "__esModule", ({ value: true }));


/***/ }),
/* 15 */
/***/ ((__unused_webpack_module, exports) => {


Object.defineProperty(exports, "__esModule", ({ value: true }));
exports["default"] = () => ({
    port: parseInt(process.env.PORT, 10) || 3000,
    aws: {
        access_key: process.env.AWS_ACCESS_KEY,
        secret_access_key: process.env.AWS_SECRET_ACCESS_KEY,
        region: process.env.AWS_SES_REGION
    },
    mailgun: {
        apiKey: process.env.MAILGUN_API_KEY,
        domainName: process.env.MAILGUN_DOMAIN_NAME
    },
    nodeEnv: process.env.NODE_ENV || 'development',
});


/***/ })
/******/ 	]);
/************************************************************************/
/******/ 	// The module cache
/******/ 	var __webpack_module_cache__ = {};
/******/ 	
/******/ 	// The require function
/******/ 	function __webpack_require__(moduleId) {
/******/ 		// Check if module is in cache
/******/ 		var cachedModule = __webpack_module_cache__[moduleId];
/******/ 		if (cachedModule !== undefined) {
/******/ 			return cachedModule.exports;
/******/ 		}
/******/ 		// Create a new module (and put it into the cache)
/******/ 		var module = __webpack_module_cache__[moduleId] = {
/******/ 			// no module.id needed
/******/ 			// no module.loaded needed
/******/ 			exports: {}
/******/ 		};
/******/ 	
/******/ 		// Execute the module function
/******/ 		__webpack_modules__[moduleId](module, module.exports, __webpack_require__);
/******/ 	
/******/ 		// Return the exports of the module
/******/ 		return module.exports;
/******/ 	}
/******/ 	
/************************************************************************/
var __webpack_exports__ = {};
// This entry need to be wrapped in an IIFE because it need to be isolated against other modules in the chunk.
(() => {
var exports = __webpack_exports__;

/**
 * This is not a production server yet!
 * This is only a minimal backend to get started.
 */
Object.defineProperty(exports, "__esModule", ({ value: true }));
const common_1 = __webpack_require__(1);
const core_1 = __webpack_require__(2);
const app_module_1 = __webpack_require__(3);
async function bootstrap() {
    const app = await core_1.NestFactory.create(app_module_1.AppModule);
    const globalPrefix = 'api';
    app.setGlobalPrefix(globalPrefix);
    const port = process.env.PORT || 3000;
    await app.listen(port);
    common_1.Logger.log(`🚀 Application is running on: http://localhost:${port}/${globalPrefix}`);
}
bootstrap();

})();

/******/ })()
;