const mysql = require('../../../mysql');
const bcrypt = require('bcrypt');
const utils = require('../../../utils');
const api_config = require('../../../utils').getApiConfig();
const jwt = require('jsonwebtoken');

exports.registrarServico = async (req, res) => {
    try {
        await mysql.execute(`
            INSERT INTO servicos (
                        id_cliente,
                        seguradora,
                        numero_da_assistencia,
                        tipo_de_servico,
                        descricao_problema,
                        checkup,
                        status
                    ) VALUES (?,?,?,?,?,?,?);`,
            [req.body.id_cliente, req.body.seguradora, req.body.numero_da_assistencia, req.body.tipo_de_servico, req.body.descricao_problema, req.body.checkup, req.body.status]
        );
        return res.status(201).send({ message: 'Serviço Cadastrado com Sucesso!' });
    } catch (error) {
        utils.getError(error);
        return res.status(500).send({ error: error });
    }
}

exports.iniciarServico = async (req, res, next) => {
    try {
        const resultado = await mysql.execute(`
                UPDATE servicos 
                SET data_inicio    = ?,
                    id_funcionario = ?,
                    status         = ?
                WHERE id_servico   = ?;
            `, [req.body.data_inicio, req.body.id_funcionario, req.body.status, req.body.id_servico]);
        return res.status(200).send({
            message: 'Serviço iniciado com sucesso',
            resultado: resultado
        });

    } catch (error) {
        utils.getError(error);
        return res.status(500).send({ error: error });
    }
}

exports.finalizarServico = async (req, res, next) => {
    try {
        const resultado = await mysql.execute(`
                UPDATE servicos 
                SET descricao_do_servico_realizado = ?,
                    utilizou_pecas                 = ?,
                    pecas                          = ?,
                    valor_pecas                    = ?,
                    houve_excedente                = ?,
                    valor_excedente                = ?,
                    avarias                        = ?,
                    problema_solucionado           = ?,
                    havera_retorno                 = ?,
                    local_limpo                    = ?,
                    cumpriu_horario                = ?,
                    data_fim                       = ?,
                    status                         = ?
                WHERE id_servico                   = ?;
            `, [req.body.descricao_do_servico_realizado, req.body.utilizou_pecas, req.body.pecas, req.body.valor_pecas, req.body.houve_excedente, req.body.valor_excedente, req.body.avarias, req.body.problema_solucionado, req.body.havera_retorno, req.body.local_limpo, req.body.cumpriu_horario, req.body.data_fim, req.body.status, req.body.id_servico]);
        return res.status(200).send({
            message: 'Serviço finalizado com sucesso',
            resultado: resultado
        });

    } catch (error) {
        utils.getError(error);
        return res.status(500).send({ error: error });
    }
}

exports.registrarImagens = async (req, res) => {
    try {
        const imagemPaht = req.file ? utils.formatarUrl(req.file.path) : null;

        await mysql.execute(`
            INSERT INTO imagens_servico (
                        id_servico,
                        imagem,
                        antes_ou_depois
                    ) VALUES (?,?,?);`,
            [req.body.id_servico, imagemPaht, req.body.antes_ou_depois]
        );

        return res.status(200).send({ message: 'Imagem adicionadas com sucesso' });
    } catch (error) {
        utils.getError(error);
        return res.status(500).send({ error: error });
    }
}

exports.pesquisarServico = async (req, res, next) => {
    try {
        let servicos;

        if (req.body.data_fim != undefined) {
            console.log(req.body.data_fim + 'T23:59:59.000Z');

            servicos = await mysql.execute(
                `SELECT * FROM servicos WHERE data_fim < ? AND data_fim > ?;`,
                [req.body.data_fim + 'T23:59:59.000Z', req.body.data_fim + 'T00:00:00.000Z']
            );
        } else if (req.body.tipo_de_servico != undefined) {
            servicos = await mysql.execute(
                `SELECT * FROM servicos WHERE tipo_de_servico = ?;`,
                [req.body.tipo_de_servico]
            );
        } else if (req.body.id_servico != undefined) {
            servicos = await mysql.execute(
                `SELECT * FROM servicos WHERE id_servico = ?;`,
                [req.body.id_servico]
            );
        } else {
            servicos = await mysql.execute(
                `SELECT * FROM servicos;`,
            );
        }

        if (servicos.length >= 1) {
            return res.status(200).send({
                mensagem: 'Seviços retornados com sucesso!',
                servicos: servicos
            });
        } 
        return res.status(200).send({
            mensagem: 'Nenhum serviço encontrado',
        });
        
    } catch (error) {
        utils.getError(error);
        return res.status(500).send({ error: error });
    }
}

exports.retornarServico = async (req, res, next) => {
    try {
        const dataServico = await mysql.execute(
            `SELECT * FROM servicos WHERE id_servico = ?;`,
            [req.body.id_servico]
        );
        const imagensServico = await mysql.execute(
            `SELECT * FROM imagens_servico WHERE id_servico = ?;`,
            [req.body.id_servico]
        );
        
        return res.status(200).send({
            mensagem: 'Serviço retornado com sucesso!',
            servico: dataServico[0],
            imagens_servico: imagensServico
        });

    } catch (error) {
        utils.getError(error);
        return res.status(500).send({ error: error });
    }
}

exports.registrarAssinaturaPrestador = async (req, res) => {
    try {

        const imagemPaht = req.file ? utils.formatarUrl(req.file.path) : null;

        

        await mysql.execute(`
            INSERT INTO assinaturas (
                        id_servico,
                        assinatura_prestador
                    ) VALUES (?,?);`,
            [req.body.id_servico, imagemPaht]
        );

        return res.status(200).send({ message: 'Assinatura do prestador adicionada com sucesso' });
    } catch (error) {
        utils.getError(error);
        return res.status(500).send({ error: error });
    }
}

exports.registrarAssinaturaCliente = async (req, res) => {
    try {
        const imagemPaht = req.file ? utils.formatarUrl(req.file.path) : null;

        await mysql.execute(`
            UPDATE assinaturas SET assinatura_cliente = ? WHERE id_servico = ?;`,
            [imagemPaht, req.body.id_servico]
        );

        return res.status(200).send({ message: 'Assinatura do cliente adicionada com sucesso' });
    } catch (error) {
        utils.getError(error);
        return res.status(500).send({ error: error });
    }
}