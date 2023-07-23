module vol_trans (
    vol_in,
    vol_out
);

input  [7:0]       vol_in;
output [31:0]      vol_out;
reg    [31:0]      vol_out;

//this is generated by python script

parameter VOL0 = 32'h07ECA9CD;
parameter VOL1 = 32'h077B2E80;
parameter VOL2 = 32'h07100C4D;
parameter VOL3 = 32'h06AAE84E;
parameter VOL4 = 32'h064B6CAE;
parameter VOL5 = 32'h05F14869;
parameter VOL6 = 32'h059C2F02;
parameter VOL7 = 32'h054BD843;
parameter VOL8 = 32'h05000000;
parameter VOL9 = 32'h04B865DE;
parameter VOL10 = 32'h0474CD1B;
parameter VOL11 = 32'h0434FC5C;
parameter VOL12 = 32'h03F8BD7A;
parameter VOL13 = 32'h03BFDD56;
parameter VOL14 = 32'h038A2BAD;
parameter VOL15 = 32'h03577AEF;
parameter VOL16 = 32'h0327A01A;
parameter VOL17 = 32'h02FA7292;
parameter VOL18 = 32'h02CFCC01;
parameter VOL19 = 32'h02A78837;
parameter VOL20 = 32'h02818508;
parameter VOL21 = 32'h025DA234;
parameter VOL22 = 32'h023BC148;
parameter VOL23 = 32'h021BC583;
parameter VOL24 = 32'h01FD93C2;
parameter VOL25 = 32'h01E11267;
parameter VOL26 = 32'h01C62940;
parameter VOL27 = 32'h01ACC17A;
parameter VOL28 = 32'h0194C584;
parameter VOL29 = 32'h017E2105;
parameter VOL30 = 32'h0168C0C6;
parameter VOL31 = 32'h015492A4;
parameter VOL32 = 32'h0141857F;
parameter VOL33 = 32'h012F892C;
parameter VOL34 = 32'h011E8E6A;
parameter VOL35 = 32'h010E86CF;
parameter VOL36 = 32'h00FF64C1;
parameter VOL37 = 32'h00F11B6A;
parameter VOL38 = 32'h00E39EA9;
parameter VOL39 = 32'h00D6E30D;
parameter VOL40 = 32'h00CADDC8;
parameter VOL41 = 32'h00BF84A6;
parameter VOL42 = 32'h00B4CE08;
parameter VOL43 = 32'h00AAB0D5;
parameter VOL44 = 32'h00A12478;
parameter VOL45 = 32'h009820D7;
parameter VOL46 = 32'h008F9E4D;
parameter VOL47 = 32'h008795A0;
parameter VOL48 = 32'h00800000;
parameter VOL49 = 32'h0078D6FD;
parameter VOL50 = 32'h00721483;
parameter VOL51 = 32'h006BB2D6;
parameter VOL52 = 32'h0065AC8C;
parameter VOL53 = 32'h005FFC89;
parameter VOL54 = 32'h005A9DF8;
parameter VOL55 = 32'h00558C4B;
parameter VOL56 = 32'h0050C336;
parameter VOL57 = 32'h004C3EA8;
parameter VOL58 = 32'h0047FACD;
parameter VOL59 = 32'h0043F405;
parameter VOL60 = 32'h004026E7;
parameter VOL61 = 32'h003C9038;
parameter VOL62 = 32'h00392CEE;
parameter VOL63 = 32'h0035FA27;
parameter VOL64 = 32'h0032F52D;
parameter VOL65 = 32'h00301B71;
parameter VOL66 = 32'h002D6A86;
parameter VOL67 = 32'h002AE026;
parameter VOL68 = 32'h00287A27;
parameter VOL69 = 32'h00263680;
parameter VOL70 = 32'h00241347;
parameter VOL71 = 32'h00220EAA;
parameter VOL72 = 32'h002026F3;
parameter VOL73 = 32'h001E5A84;
parameter VOL74 = 32'h001CA7D7;
parameter VOL75 = 32'h001B0D7B;
parameter VOL76 = 32'h00198A13;
parameter VOL77 = 32'h00181C57;
parameter VOL78 = 32'h0016C311;
parameter VOL79 = 32'h00157D1B;
parameter VOL80 = 32'h00144961;
parameter VOL81 = 32'h001326DD;
parameter VOL82 = 32'h0012149A;
parameter VOL83 = 32'h001111AF;
parameter VOL84 = 32'h00101D3F;
parameter VOL85 = 32'h000F367C;
parameter VOL86 = 32'h000E5CA1;
parameter VOL87 = 32'h000D8EF6;
parameter VOL88 = 32'h000CCCCD;
parameter VOL89 = 32'h000C1580;
parameter VOL90 = 32'h000B6873;
parameter VOL91 = 32'h000AC515;
parameter VOL92 = 32'h000A2ADB;
parameter VOL93 = 32'h00099941;
parameter VOL94 = 32'h00090FCC;
parameter VOL95 = 32'h00088E08;
parameter VOL96 = 32'h00081385;
parameter VOL97 = 32'h00079FDE;
parameter VOL98 = 32'h000732AE;
parameter VOL99 = 32'h0006CB9A;
parameter VOL100 = 32'h00066A4A;
parameter VOL101 = 32'h00060E6C;
parameter VOL102 = 32'h0005B7B1;
parameter VOL103 = 32'h000565D1;
parameter VOL104 = 32'h00051884;
parameter VOL105 = 32'h0004CF8B;
parameter VOL106 = 32'h00048AA7;
parameter VOL107 = 32'h0004499D;
parameter VOL108 = 32'h00040C37;
parameter VOL109 = 32'h0003D240;
parameter VOL110 = 32'h00039B87;
parameter VOL111 = 32'h000367DE;
parameter VOL112 = 32'h00033718;
parameter VOL113 = 32'h0003090D;
parameter VOL114 = 32'h0002DD96;
parameter VOL115 = 32'h0002B48C;
parameter VOL116 = 32'h00028DCF;
parameter VOL117 = 32'h0002693C;
parameter VOL118 = 32'h000246B5;
parameter VOL119 = 32'h0002261C;
parameter VOL120 = 32'h00020756;
parameter VOL121 = 32'h0001EA49;
parameter VOL122 = 32'h0001CEDC;
parameter VOL123 = 32'h0001B4F8;
parameter VOL124 = 32'h00019C86;
parameter VOL125 = 32'h00018573;
parameter VOL126 = 32'h00016FAA;
parameter VOL127 = 32'h00015B19;
parameter VOL128 = 32'h000147AE;
parameter VOL129 = 32'h0001355A;
parameter VOL130 = 32'h0001240C;
parameter VOL131 = 32'h000113B5;
parameter VOL132 = 32'h00010449;
parameter VOL133 = 32'h0000F5BA;
parameter VOL134 = 32'h0000E7FB;
parameter VOL135 = 32'h0000DB01;
parameter VOL136 = 32'h0000CEC1;
parameter VOL137 = 32'h0000C330;
parameter VOL138 = 32'h0000B845;
parameter VOL139 = 32'h0000ADF6;
parameter VOL140 = 32'h0000A43B;
parameter VOL141 = 32'h00009B0B;
parameter VOL142 = 32'h0000925F;
parameter VOL143 = 32'h00008A2E;
parameter VOL144 = 32'h00008274;
parameter VOL145 = 32'h00007B28;
parameter VOL146 = 32'h00007444;
parameter VOL147 = 32'h00006DC3;
parameter VOL148 = 32'h0000679F;
parameter VOL149 = 32'h000061D3;
parameter VOL150 = 32'h00005C5A;
parameter VOL151 = 32'h00005730;
parameter VOL152 = 32'h0000524F;
parameter VOL153 = 32'h00004DB5;
parameter VOL154 = 32'h0000495C;
parameter VOL155 = 32'h00004541;
parameter VOL156 = 32'h00004161;
parameter VOL157 = 32'h00003DB9;
parameter VOL158 = 32'h00003A45;
parameter VOL159 = 32'h00003703;
parameter VOL160 = 32'h000033EF;
parameter VOL161 = 32'h00003107;
parameter VOL162 = 32'h00002E49;
parameter VOL163 = 32'h00002BB2;
parameter VOL164 = 32'h00002941;
parameter VOL165 = 32'h000026F2;
parameter VOL166 = 32'h000024C4;
parameter VOL167 = 32'h000022B6;
parameter VOL168 = 32'h000020C5;
parameter VOL169 = 32'h00001EEF;
parameter VOL170 = 32'h00001D34;
parameter VOL171 = 32'h00001B92;
parameter VOL172 = 32'h00001A07;
parameter VOL173 = 32'h00001893;
parameter VOL174 = 32'h00001733;
parameter VOL175 = 32'h000015E6;
parameter VOL176 = 32'h000014AD;
parameter VOL177 = 32'h00001385;
parameter VOL178 = 32'h0000126D;
parameter VOL179 = 32'h00001165;
parameter VOL180 = 32'h0000106C;
parameter VOL181 = 32'h00000F81;
parameter VOL182 = 32'h00000EA3;
parameter VOL183 = 32'h00000DD1;
parameter VOL184 = 32'h00000D0C;
parameter VOL185 = 32'h00000C51;
parameter VOL186 = 32'h00000BA0;
parameter VOL187 = 32'h00000AFA;
parameter VOL188 = 32'h00000A5D;
parameter VOL189 = 32'h000009C8;
parameter VOL190 = 32'h0000093C;
parameter VOL191 = 32'h000008B8;
parameter VOL192 = 32'h0000083B;
parameter VOL193 = 32'h000007C5;
parameter VOL194 = 32'h00000756;
parameter VOL195 = 32'h000006ED;
parameter VOL196 = 32'h0000068A;
parameter VOL197 = 32'h0000062C;
parameter VOL198 = 32'h000005D4;
parameter VOL199 = 32'h00000580;
parameter VOL200 = 32'h00000532;
parameter VOL201 = 32'h000004E7;
parameter VOL202 = 32'h000004A1;
parameter VOL203 = 32'h0000045F;
parameter VOL204 = 32'h00000420;
parameter VOL205 = 32'h000003E5;
parameter VOL206 = 32'h000003AD;
parameter VOL207 = 32'h00000379;
parameter VOL208 = 32'h00000347;
parameter VOL209 = 32'h00000318;
parameter VOL210 = 32'h000002EC;
parameter VOL211 = 32'h000002C2;
parameter VOL212 = 32'h0000029A;
parameter VOL213 = 32'h00000275;
parameter VOL214 = 32'h00000252;
parameter VOL215 = 32'h00000231;
parameter VOL216 = 32'h00000211;
parameter VOL217 = 32'h000001F4;
parameter VOL218 = 32'h000001D8;
parameter VOL219 = 32'h000001BD;
parameter VOL220 = 32'h000001A4;
parameter VOL221 = 32'h0000018D;
parameter VOL222 = 32'h00000177;
parameter VOL223 = 32'h00000162;
parameter VOL224 = 32'h0000014E;
parameter VOL225 = 32'h0000013B;
parameter VOL226 = 32'h0000012A;
parameter VOL227 = 32'h00000119;
parameter VOL228 = 32'h00000109;
parameter VOL229 = 32'h000000FA;
parameter VOL230 = 32'h000000EC;
parameter VOL231 = 32'h000000DF;
parameter VOL232 = 32'h000000D3;
parameter VOL233 = 32'h000000C7;
parameter VOL234 = 32'h000000BC;
parameter VOL235 = 32'h000000B1;
parameter VOL236 = 32'h000000A7;
parameter VOL237 = 32'h0000009E;
parameter VOL238 = 32'h00000095;
parameter VOL239 = 32'h0000008D;
parameter VOL240 = 32'h00000085;
parameter VOL241 = 32'h0000007E;
parameter VOL242 = 32'h00000076;
parameter VOL243 = 32'h00000070;
parameter VOL244 = 32'h0000006A;
parameter VOL245 = 32'h00000064;
parameter VOL246 = 32'h0000005E;
parameter VOL247 = 32'h00000059;
parameter VOL248 = 32'h00000054;
parameter VOL249 = 32'h0000004F;
parameter VOL250 = 32'h0000004B;
parameter VOL251 = 32'h00000047;
parameter VOL252 = 32'h00000043;
parameter VOL253 = 32'h0000003F;
parameter VOL254 = 32'h0000003B;
parameter VOL255 = 32'h00000000;

always @ (*) begin
	case(vol_in)
		32'd0:
			vol_out = VOL0;
		32'd1:
			vol_out = VOL1;
		32'd2:
			vol_out = VOL2;
		32'd3:
			vol_out = VOL3;
		32'd4:
			vol_out = VOL4;
		32'd5:
			vol_out = VOL5;
		32'd6:
			vol_out = VOL6;
		32'd7:
			vol_out = VOL7;
		32'd8:
			vol_out = VOL8;
		32'd9:
			vol_out = VOL9;
		32'd10:
			vol_out = VOL10;
		32'd11:
			vol_out = VOL11;
		32'd12:
			vol_out = VOL12;
		32'd13:
			vol_out = VOL13;
		32'd14:
			vol_out = VOL14;
		32'd15:
			vol_out = VOL15;
		32'd16:
			vol_out = VOL16;
		32'd17:
			vol_out = VOL17;
		32'd18:
			vol_out = VOL18;
		32'd19:
			vol_out = VOL19;
		32'd20:
			vol_out = VOL20;
		32'd21:
			vol_out = VOL21;
		32'd22:
			vol_out = VOL22;
		32'd23:
			vol_out = VOL23;
		32'd24:
			vol_out = VOL24;
		32'd25:
			vol_out = VOL25;
		32'd26:
			vol_out = VOL26;
		32'd27:
			vol_out = VOL27;
		32'd28:
			vol_out = VOL28;
		32'd29:
			vol_out = VOL29;
		32'd30:
			vol_out = VOL30;
		32'd31:
			vol_out = VOL31;
		32'd32:
			vol_out = VOL32;
		32'd33:
			vol_out = VOL33;
		32'd34:
			vol_out = VOL34;
		32'd35:
			vol_out = VOL35;
		32'd36:
			vol_out = VOL36;
		32'd37:
			vol_out = VOL37;
		32'd38:
			vol_out = VOL38;
		32'd39:
			vol_out = VOL39;
		32'd40:
			vol_out = VOL40;
		32'd41:
			vol_out = VOL41;
		32'd42:
			vol_out = VOL42;
		32'd43:
			vol_out = VOL43;
		32'd44:
			vol_out = VOL44;
		32'd45:
			vol_out = VOL45;
		32'd46:
			vol_out = VOL46;
		32'd47:
			vol_out = VOL47;
		32'd48:
			vol_out = VOL48;
		32'd49:
			vol_out = VOL49;
		32'd50:
			vol_out = VOL50;
		32'd51:
			vol_out = VOL51;
		32'd52:
			vol_out = VOL52;
		32'd53:
			vol_out = VOL53;
		32'd54:
			vol_out = VOL54;
		32'd55:
			vol_out = VOL55;
		32'd56:
			vol_out = VOL56;
		32'd57:
			vol_out = VOL57;
		32'd58:
			vol_out = VOL58;
		32'd59:
			vol_out = VOL59;
		32'd60:
			vol_out = VOL60;
		32'd61:
			vol_out = VOL61;
		32'd62:
			vol_out = VOL62;
		32'd63:
			vol_out = VOL63;
		32'd64:
			vol_out = VOL64;
		32'd65:
			vol_out = VOL65;
		32'd66:
			vol_out = VOL66;
		32'd67:
			vol_out = VOL67;
		32'd68:
			vol_out = VOL68;
		32'd69:
			vol_out = VOL69;
		32'd70:
			vol_out = VOL70;
		32'd71:
			vol_out = VOL71;
		32'd72:
			vol_out = VOL72;
		32'd73:
			vol_out = VOL73;
		32'd74:
			vol_out = VOL74;
		32'd75:
			vol_out = VOL75;
		32'd76:
			vol_out = VOL76;
		32'd77:
			vol_out = VOL77;
		32'd78:
			vol_out = VOL78;
		32'd79:
			vol_out = VOL79;
		32'd80:
			vol_out = VOL80;
		32'd81:
			vol_out = VOL81;
		32'd82:
			vol_out = VOL82;
		32'd83:
			vol_out = VOL83;
		32'd84:
			vol_out = VOL84;
		32'd85:
			vol_out = VOL85;
		32'd86:
			vol_out = VOL86;
		32'd87:
			vol_out = VOL87;
		32'd88:
			vol_out = VOL88;
		32'd89:
			vol_out = VOL89;
		32'd90:
			vol_out = VOL90;
		32'd91:
			vol_out = VOL91;
		32'd92:
			vol_out = VOL92;
		32'd93:
			vol_out = VOL93;
		32'd94:
			vol_out = VOL94;
		32'd95:
			vol_out = VOL95;
		32'd96:
			vol_out = VOL96;
		32'd97:
			vol_out = VOL97;
		32'd98:
			vol_out = VOL98;
		32'd99:
			vol_out = VOL99;
		32'd100:
			vol_out = VOL100;
		32'd101:
			vol_out = VOL101;
		32'd102:
			vol_out = VOL102;
		32'd103:
			vol_out = VOL103;
		32'd104:
			vol_out = VOL104;
		32'd105:
			vol_out = VOL105;
		32'd106:
			vol_out = VOL106;
		32'd107:
			vol_out = VOL107;
		32'd108:
			vol_out = VOL108;
		32'd109:
			vol_out = VOL109;
		32'd110:
			vol_out = VOL110;
		32'd111:
			vol_out = VOL111;
		32'd112:
			vol_out = VOL112;
		32'd113:
			vol_out = VOL113;
		32'd114:
			vol_out = VOL114;
		32'd115:
			vol_out = VOL115;
		32'd116:
			vol_out = VOL116;
		32'd117:
			vol_out = VOL117;
		32'd118:
			vol_out = VOL118;
		32'd119:
			vol_out = VOL119;
		32'd120:
			vol_out = VOL120;
		32'd121:
			vol_out = VOL121;
		32'd122:
			vol_out = VOL122;
		32'd123:
			vol_out = VOL123;
		32'd124:
			vol_out = VOL124;
		32'd125:
			vol_out = VOL125;
		32'd126:
			vol_out = VOL126;
		32'd127:
			vol_out = VOL127;
		32'd128:
			vol_out = VOL128;
		32'd129:
			vol_out = VOL129;
		32'd130:
			vol_out = VOL130;
		32'd131:
			vol_out = VOL131;
		32'd132:
			vol_out = VOL132;
		32'd133:
			vol_out = VOL133;
		32'd134:
			vol_out = VOL134;
		32'd135:
			vol_out = VOL135;
		32'd136:
			vol_out = VOL136;
		32'd137:
			vol_out = VOL137;
		32'd138:
			vol_out = VOL138;
		32'd139:
			vol_out = VOL139;
		32'd140:
			vol_out = VOL140;
		32'd141:
			vol_out = VOL141;
		32'd142:
			vol_out = VOL142;
		32'd143:
			vol_out = VOL143;
		32'd144:
			vol_out = VOL144;
		32'd145:
			vol_out = VOL145;
		32'd146:
			vol_out = VOL146;
		32'd147:
			vol_out = VOL147;
		32'd148:
			vol_out = VOL148;
		32'd149:
			vol_out = VOL149;
		32'd150:
			vol_out = VOL150;
		32'd151:
			vol_out = VOL151;
		32'd152:
			vol_out = VOL152;
		32'd153:
			vol_out = VOL153;
		32'd154:
			vol_out = VOL154;
		32'd155:
			vol_out = VOL155;
		32'd156:
			vol_out = VOL156;
		32'd157:
			vol_out = VOL157;
		32'd158:
			vol_out = VOL158;
		32'd159:
			vol_out = VOL159;
		32'd160:
			vol_out = VOL160;
		32'd161:
			vol_out = VOL161;
		32'd162:
			vol_out = VOL162;
		32'd163:
			vol_out = VOL163;
		32'd164:
			vol_out = VOL164;
		32'd165:
			vol_out = VOL165;
		32'd166:
			vol_out = VOL166;
		32'd167:
			vol_out = VOL167;
		32'd168:
			vol_out = VOL168;
		32'd169:
			vol_out = VOL169;
		32'd170:
			vol_out = VOL170;
		32'd171:
			vol_out = VOL171;
		32'd172:
			vol_out = VOL172;
		32'd173:
			vol_out = VOL173;
		32'd174:
			vol_out = VOL174;
		32'd175:
			vol_out = VOL175;
		32'd176:
			vol_out = VOL176;
		32'd177:
			vol_out = VOL177;
		32'd178:
			vol_out = VOL178;
		32'd179:
			vol_out = VOL179;
		32'd180:
			vol_out = VOL180;
		32'd181:
			vol_out = VOL181;
		32'd182:
			vol_out = VOL182;
		32'd183:
			vol_out = VOL183;
		32'd184:
			vol_out = VOL184;
		32'd185:
			vol_out = VOL185;
		32'd186:
			vol_out = VOL186;
		32'd187:
			vol_out = VOL187;
		32'd188:
			vol_out = VOL188;
		32'd189:
			vol_out = VOL189;
		32'd190:
			vol_out = VOL190;
		32'd191:
			vol_out = VOL191;
		32'd192:
			vol_out = VOL192;
		32'd193:
			vol_out = VOL193;
		32'd194:
			vol_out = VOL194;
		32'd195:
			vol_out = VOL195;
		32'd196:
			vol_out = VOL196;
		32'd197:
			vol_out = VOL197;
		32'd198:
			vol_out = VOL198;
		32'd199:
			vol_out = VOL199;
		32'd200:
			vol_out = VOL200;
		32'd201:
			vol_out = VOL201;
		32'd202:
			vol_out = VOL202;
		32'd203:
			vol_out = VOL203;
		32'd204:
			vol_out = VOL204;
		32'd205:
			vol_out = VOL205;
		32'd206:
			vol_out = VOL206;
		32'd207:
			vol_out = VOL207;
		32'd208:
			vol_out = VOL208;
		32'd209:
			vol_out = VOL209;
		32'd210:
			vol_out = VOL210;
		32'd211:
			vol_out = VOL211;
		32'd212:
			vol_out = VOL212;
		32'd213:
			vol_out = VOL213;
		32'd214:
			vol_out = VOL214;
		32'd215:
			vol_out = VOL215;
		32'd216:
			vol_out = VOL216;
		32'd217:
			vol_out = VOL217;
		32'd218:
			vol_out = VOL218;
		32'd219:
			vol_out = VOL219;
		32'd220:
			vol_out = VOL220;
		32'd221:
			vol_out = VOL221;
		32'd222:
			vol_out = VOL222;
		32'd223:
			vol_out = VOL223;
		32'd224:
			vol_out = VOL224;
		32'd225:
			vol_out = VOL225;
		32'd226:
			vol_out = VOL226;
		32'd227:
			vol_out = VOL227;
		32'd228:
			vol_out = VOL228;
		32'd229:
			vol_out = VOL229;
		32'd230:
			vol_out = VOL230;
		32'd231:
			vol_out = VOL231;
		32'd232:
			vol_out = VOL232;
		32'd233:
			vol_out = VOL233;
		32'd234:
			vol_out = VOL234;
		32'd235:
			vol_out = VOL235;
		32'd236:
			vol_out = VOL236;
		32'd237:
			vol_out = VOL237;
		32'd238:
			vol_out = VOL238;
		32'd239:
			vol_out = VOL239;
		32'd240:
			vol_out = VOL240;
		32'd241:
			vol_out = VOL241;
		32'd242:
			vol_out = VOL242;
		32'd243:
			vol_out = VOL243;
		32'd244:
			vol_out = VOL244;
		32'd245:
			vol_out = VOL245;
		32'd246:
			vol_out = VOL246;
		32'd247:
			vol_out = VOL247;
		32'd248:
			vol_out = VOL248;
		32'd249:
			vol_out = VOL249;
		32'd250:
			vol_out = VOL250;
		32'd251:
			vol_out = VOL251;
		32'd252:
			vol_out = VOL252;
		32'd253:
			vol_out = VOL253;
		32'd254:
			vol_out = VOL254;
		32'd255:
			vol_out = VOL255;
    endcase
end

endmodule