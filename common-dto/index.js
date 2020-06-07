"use strict";
var __createBinding = (this && this.__createBinding) || (Object.create ? (function(o, m, k, k2) {
    if (k2 === undefined) k2 = k;
    Object.defineProperty(o, k2, { enumerable: true, get: function() { return m[k]; } });
}) : (function(o, m, k, k2) {
    if (k2 === undefined) k2 = k;
    o[k2] = m[k];
}));
var __exportStar = (this && this.__exportStar) || function(m, exports) {
    for (var p in m) if (p !== "default" && !exports.hasOwnProperty(p)) __createBinding(exports, m, p);
};
exports.__esModule = true;
__exportStar(require("./dto/user.dto"), exports);
__exportStar(require("./dto/appointment.dto"), exports);
__exportStar(require("./dto/doctor.dto"), exports);
__exportStar(require("./dto/account.dto"), exports);
__exportStar(require("./dto/doctor_config_preconsultation.dto"), exports);
__exportStar(require("./interface/index"), exports);
__exportStar(require("./config/index"), exports);
