import { Controller, Get, UseGuards } from '@nestjs/common';
import { AuthGuard } from '@nestjs/passport';
import { ApiBearerAuth, ApiUnauthorizedResponse, ApiOkResponse } from '@nestjs/swagger';
import { Roles } from 'src/common/decorator/roles.decorator';
import { RolesPolicy } from 'src/common/decorator/roles-policy.decorator';

@Controller('user')
@UseGuards(AuthGuard())
export class UserController {

    @ApiOkResponse({ description: 'Update current user' })
    @ApiUnauthorizedResponse()
    @Get('list')
    @ApiBearerAuth('JWT')
    @UseGuards(AuthGuard())
    @Roles('admin')
    @RolesPolicy('user_list_allow')
    getList() {
        return [];
    }
}
